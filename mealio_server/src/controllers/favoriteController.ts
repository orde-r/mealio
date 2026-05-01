import { Response } from "express";
import { z } from "zod";
import type { AuthRequest } from "../middleware/authMiddleware";
import {
  addFavorite,
  getUserFavorites,
  removeFavorite,
} from "../repository/favoriteRepository";

const favoriteParamsSchema = z.object({
  restaurantId: z.string().uuid("restaurantId must be a valid UUID"),
});

function validationErrorResponse(error: z.ZodError) {
  return error.issues.map((issue) => ({
    field: issue.path.join("."),
    message: issue.message,
  }));
}

function mapRepositoryError(error: unknown, res: Response): boolean {
  if (!(error instanceof Error)) {
    return false;
  }

  if (error.message === "User not found") {
    res.status(404).json({ error: "User not found" });
    return true;
  }

  if (error.message === "Restaurant not found") {
    res.status(404).json({ error: "Restaurant not found" });
    return true;
  }

  return false;
}

export const addFavoriteRestaurant = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const parsedParams = favoriteParamsSchema.safeParse(req.params);
    if (!parsedParams.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedParams.error),
      });
      return;
    }

    const { restaurantId } = parsedParams.data;
    const favorites = await addFavorite(userId, restaurantId);

    res.status(200).json({
      status: "Successfully added to favorite",
      favorites: favorites,
    });
  } catch (error) {
    if (mapRepositoryError(error, res)) {
      return;
    }

    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const deleteFavoriteRestaurant = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const parsedParams = favoriteParamsSchema.safeParse(req.params);
    if (!parsedParams.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedParams.error),
      });
      return;
    }

    const { restaurantId } = parsedParams.data;
    const favorites = await removeFavorite(userId, restaurantId);

    res.status(200).json({
      status: "Successfully removed from favorite",
      favorites: favorites,
    });
  } catch (error) {
    if (mapRepositoryError(error, res)) {
      return;
    }

    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const getFavoriteRestaurants = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const favorites = await getUserFavorites(userId);

    res.status(200).json(favorites);
  } catch (error) {
    if (mapRepositoryError(error, res)) {
      return;
    }

    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
