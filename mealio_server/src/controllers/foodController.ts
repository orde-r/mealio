import { Response } from "express";
import { z } from "zod";
import { GoogleGenerativeAI } from "@google/generative-ai";
import type { AuthRequest } from "../middleware/authMiddleware";
import { findUserById } from "../repository/userRepository";
import {
  findRecommendedRestaurants,
  type RecommendationCandidate,
} from "../repository/restaurantRepository";

const recommendSchema = z.object({
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  radiusKm: z.number().positive(),
  maxStartingPrice: z.number().positive(),
  mood: z.string().trim().min(1, "mood is required"),
});

function validationErrorResponse(error: z.ZodError) {
  return error.issues.map((issue) => ({
    field: issue.path.join("."),
    message: issue.message,
  }));
}

type ScoredCandidate = RecommendationCandidate & {
  aiScore?: number;
};

type AiRanking = {
  id: string;
  score: number;
};

const AI_MAX_CANDIDATES = 30;

const aiRankingSchema = z.object({
  rankings: z.array(
    z.object({
      id: z.string(),
      score: z.number().min(0).max(100),
    }),
  ),
});

function extractJsonPayload(text: string): string | null {
  const trimmed = text.trim();
  if (trimmed.startsWith("{") && trimmed.endsWith("}")) {
    return trimmed;
  }

  const firstBrace = trimmed.indexOf("{");
  const lastBrace = trimmed.lastIndexOf("}");
  if (firstBrace === -1 || lastBrace === -1 || lastBrace <= firstBrace) {
    return null;
  }

  return trimmed.slice(firstBrace, lastBrace + 1);
}

function parseAiRankings(text: string): AiRanking[] | null {
  const jsonPayload = extractJsonPayload(text);
  if (!jsonPayload) {
    return null;
  }

  try {
    const parsed = JSON.parse(jsonPayload);
    const validated = aiRankingSchema.safeParse(parsed);
    if (!validated.success) {
      return null;
    }
    return validated.data.rankings;
  } catch {
    return null;
  }
}

function buildGeminiPrompt(params: {
  mood: string;
  maxStartingPrice: number;
  candidates: RecommendationCandidate[];
}) {
  const { mood, maxStartingPrice, candidates } = params;

  const promptPayload = {
    mood,
    maxStartingPrice,
    candidates: candidates.map((candidate) => ({
      id: candidate.id,
      name: candidate.name,
      distanceKm: Number(candidate.distanceKm.toFixed(3)),
      startingPrice: candidate.startingPrice,
      rating: candidate.rating,
      ratingCount: candidate.ratingCount,
      tags: candidate.tags ?? [],
      signatureDishes: candidate.signatureDishes ?? [],
    })),
  };

  return [
    "You are a ranking engine for restaurant recommendations.",
    "Return JSON only with this exact shape:",
    '{"rankings":[{"id":"...","score":0}]}',
    "Rules:",
    "1) Include every candidate id exactly once.",
    "2) Score 0-100, higher is better.",
    "3) Rank by these factors in order: mood match with tags/signatureDishes, distanceKm (closer is better), rating and ratingCount (higher is better), startingPrice (closer to or under maxStartingPrice is better).",
    "4) Do not filter out candidates.",
    "5) Sort rankings by score descending.",
    "Input:",
    JSON.stringify(promptPayload),
  ].join("\n");
}

async function rankWithGemini(params: {
  mood: string;
  maxStartingPrice: number;
  candidates: RecommendationCandidate[];
}): Promise<{ ranked: ScoredCandidate[]; model: string } | null> {
  const apiKey = process.env.GEMINI_API_KEY?.trim();
  if (!apiKey) {
    return null;
  }

  if (params.candidates.length < 2) {
    return null;
  }

  const modelName = process.env.GEMINI_MODEL?.trim() || "gemini-3-flash-preview";
  const genAi = new GoogleGenerativeAI(apiKey);
  const model = genAi.getGenerativeModel({
    model: modelName,
    generationConfig: {
      temperature: 0,
      topP: 1,
      topK: 1,
      maxOutputTokens: 8192,
      responseMimeType: "application/json",
    },
  });

  const aiCandidates = params.candidates.slice(0, AI_MAX_CANDIDATES);
  const prompt = buildGeminiPrompt({
    mood: params.mood,
    maxStartingPrice: params.maxStartingPrice,
    candidates: aiCandidates,
  });

  const response = await model.generateContent(prompt);
  const text = response.response.text();
  if (process.env.GEMINI_DEBUG?.trim() === "true") {
    console.debug(`Gemini raw response (${modelName}): ${text}`);
  }
  const rankings = parseAiRankings(text);
  if (!rankings || rankings.length === 0) {
    return null;
  }

  const candidateMap = new Map(
    aiCandidates.map((candidate) => [candidate.id, candidate]),
  );
  const scoredCandidates: ScoredCandidate[] = [];
  const seenIds = new Set<string>();

  rankings
    .filter((ranking) => candidateMap.has(ranking.id))
    .sort((left, right) => right.score - left.score)
    .forEach((ranking) => {
      const candidate = candidateMap.get(ranking.id);
      if (!candidate || seenIds.has(ranking.id)) {
        return;
      }

      seenIds.add(ranking.id);
      scoredCandidates.push({
        ...candidate,
        aiScore: ranking.score,
      });
    });

  const remainingAiCandidates = aiCandidates.filter(
    (candidate) => !seenIds.has(candidate.id),
  );
  const aiCandidateIds = new Set(aiCandidates.map((candidate) => candidate.id));
  const remainingCandidates = params.candidates.filter(
    (candidate) => !aiCandidateIds.has(candidate.id),
  );

  return {
    ranked: [
      ...scoredCandidates,
      ...remainingAiCandidates,
      ...remainingCandidates,
    ],
    model: modelName,
  };
}

export const recommendRestaurants = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const parsedBody = recommendSchema.safeParse(req.body);
    if (!parsedBody.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedBody.error),
      });
      return;
    }

    const { latitude, longitude, radiusKm, maxStartingPrice, mood } =
      parsedBody.data;

    const user = await findUserById(userId);
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    // Accept values like "25" as "25k" to match seed pricing units.
    //TODO: Confirm the pricing units
    const normalizedMaxStartingPrice =
      maxStartingPrice <= 1000 ? maxStartingPrice * 1000 : maxStartingPrice;

    const candidates = await findRecommendedRestaurants({
      latitude,
      longitude,
      radiusKm,
      maxStartingPrice: normalizedMaxStartingPrice,
      requiresHalal: user.requiresHalal ?? false,
      requiresVegan: user.requiresVegan ?? false,
      allergies: user.allergies ?? [],
    });

    let rankedCandidates: ScoredCandidate[] = candidates;
    let scoringSource = "fallback";
    let scoringModel: string | null = null;

    try {
      const aiResult = await rankWithGemini({
        mood,
        maxStartingPrice: normalizedMaxStartingPrice,
        candidates,
      });
      if (aiResult) {
        rankedCandidates = aiResult.ranked;
        scoringSource = "gemini";
        scoringModel = aiResult.model;
      }
    } catch (error) {
      console.warn("Gemini ranking failed, using fallback\n", error);
    }

    res.status(200).json({
      message: "Recommendations fetched successfully",
      mood,
      scoring: {
        source: scoringSource,
        model: scoringModel,
      },
      candidates: rankedCandidates,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
