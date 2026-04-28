import { Response } from "express";
import { z } from "zod";
import type { AuthRequest } from "../middleware/authMiddleware";
import { findUserById } from "../repository/userRepository";
import { findRecommendedRestaurants } from "../repository/restaurantRepository";

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

    res.status(200).json({
      message: "Recommendations fetched successfully",
      mood,
      candidates,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
