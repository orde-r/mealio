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
  maxStartingPrice: z.number().positive().optional(),
  minStartingPrice: z.number().positive().optional(),
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

const AI_MAX_CANDIDATES = 99;
const DEFAULT_GEMINI_MAX_OUTPUT_TOKENS = 16384;

const aiRankingEntrySchema = z.object({
  id: z.string().trim().min(1),
  score: z.coerce.number().min(0).max(100),
});

const aiRankingPayloadSchema = z.object({
  rankings: z.array(aiRankingEntrySchema),
});

const aiRankingArraySchema = z.array(aiRankingEntrySchema);

function extractJsonPayload(text: string): string | null {
  const trimmed = text.trim();

  // Strip markdown code fences if present
  const noFences = trimmed
    .replace(/^```(?:json)?\s*\n?/i, "")
    .replace(/\n?```\s*$/, "")
    .trim();

  if (noFences.startsWith("{") && noFences.endsWith("}")) {
    return noFences;
  }

  const firstBrace = noFences.indexOf("{");
  const lastBrace = noFences.lastIndexOf("}");
  if (firstBrace === -1 || lastBrace === -1 || lastBrace <= firstBrace) {
    return null;
  }

  return noFences.slice(firstBrace, lastBrace + 1);
}

function repairJson(text: string): string {
  return text
    .replace(/,\s*,/g, ",")
    .replace(/,\s*]/g, "]")
    .replace(/,\s*}/g, "}");
}

function validateAiRankingsPayload(parsed: unknown): AiRanking[] | null {
  const objectResult = aiRankingPayloadSchema.safeParse(parsed);
  if (objectResult.success) {
    return objectResult.data.rankings;
  }

  const arrayResult = aiRankingArraySchema.safeParse(parsed);
  if (arrayResult.success) {
    return arrayResult.data;
  }

  return null;
}

function extractRankingObjects(text: string): AiRanking[] {
  const rankings: AiRanking[] = [];
  const seenIds = new Set<string>();
  const rankingObjectRegex =
    /\{\s*"id"\s*:\s*"([^"]+)"\s*,\s*"score"\s*:\s*(-?\d+(?:\.\d+)?)\s*\}/g;

  let match: RegExpExecArray | null;
  while ((match = rankingObjectRegex.exec(text)) !== null) {
    const validated = aiRankingEntrySchema.safeParse({
      id: match[1],
      score: Number(match[2]),
    });

    if (!validated.success || seenIds.has(validated.data.id)) {
      continue;
    }

    seenIds.add(validated.data.id);
    rankings.push(validated.data);
  }

  return rankings;
}

function parseAiRankings(text: string): AiRanking[] | null {
  const recoverRankings = (): AiRanking[] | null => {
    const extractedRankings = extractRankingObjects(text);
    if (extractedRankings.length === 0) {
      return null;
    }

    if (process.env.GEMINI_DEBUG?.trim() === "true") {
      console.debug(
        `[parseAiRankings] Recovered ${extractedRankings.length} ranking objects from raw Gemini output`,
      );
    }

    return extractedRankings;
  };

  const jsonPayload = extractJsonPayload(text);
  if (!jsonPayload) {
    const recoveredRankings = recoverRankings();
    if (recoveredRankings) {
      return recoveredRankings;
    }

    console.warn("[parseAiRankings] Failed to extract JSON payload");
    return null;
  }

  try {
    const repaired = repairJson(jsonPayload);
    const parsed = JSON.parse(repaired);
    const validated = validateAiRankingsPayload(parsed);
    if (validated) {
      return validated;
    }

    const recoveredRankings = recoverRankings();
    if (recoveredRankings) {
      return recoveredRankings;
    }

    console.warn("[parseAiRankings] Schema validation failed");
    return null;
  } catch (error) {
    const recoveredRankings = recoverRankings();
    if (recoveredRankings) {
      if (process.env.GEMINI_DEBUG?.trim() === "true") {
        console.debug(
          `[parseAiRankings] Recovered ${recoveredRankings.length} ranking objects after a Gemini JSON parse failure`,
        );
      }
      return recoveredRankings;
    }

    console.warn("[parseAiRankings] JSON parse error:", error);
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

function getGeminiMaxOutputTokens(): number {
  const rawValue = process.env.GEMINI_MAX_OUTPUT_TOKENS?.trim();
  if (!rawValue) {
    return DEFAULT_GEMINI_MAX_OUTPUT_TOKENS;
  }

  const parsedValue = Number(rawValue);
  if (!Number.isInteger(parsedValue) || parsedValue <= 0) {
    return DEFAULT_GEMINI_MAX_OUTPUT_TOKENS;
  }

  return parsedValue;
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

  const modelName =
    process.env.GEMINI_MODEL?.trim() || "gemini-3-flash-preview";
  const genAi = new GoogleGenerativeAI(apiKey);
  const model = genAi.getGenerativeModel({
    model: modelName,
    generationConfig: {
      temperature: 0,
      topP: 1,
      topK: 1,
      maxOutputTokens: getGeminiMaxOutputTokens(),
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

    const {
      latitude,
      longitude,
      radiusKm,
      maxStartingPrice,
      minStartingPrice,
      mood,
    } = parsedBody.data;

    const user = await findUserById(userId);
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    // Accept values like "25" as "25k" to match seed pricing units.
    //TODO: Confirm the pricing units
    const normalizedMaxStartingPrice =
      maxStartingPrice != null && maxStartingPrice <= 1000
        ? maxStartingPrice * 1000
        : maxStartingPrice;
    const normalizedMinStartingPrice =
      minStartingPrice != null && minStartingPrice <= 1000
        ? minStartingPrice * 1000
        : minStartingPrice;

    const candidates = await findRecommendedRestaurants({
      latitude,
      longitude,
      radiusKm,
      maxStartingPrice: normalizedMaxStartingPrice ?? 999999999,
      minStartingPrice: normalizedMinStartingPrice,
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
        maxStartingPrice: normalizedMaxStartingPrice ?? 999999999,
        candidates,
      });
      if (process.env.GEMINI_DEBUG?.trim() === "true") {
        console.debug(
          "[recommendRestaurants] AI result:",
          aiResult
            ? `got ${aiResult.ranked.length} ranked`
            : "null (fell back)",
        );
      }
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
