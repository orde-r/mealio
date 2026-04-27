import { Request, Response } from "express";
import bcrypt from "bcrypt";
import { z } from "zod";
import {
  findUserById,
  updatePassword,
  updatePreferences,
  updateUsername,
} from "../repository/userRepository";
import type { AuthRequest } from "../middleware/authMiddleware";

const updateNameSchema = z.object({
  name: z.string().trim().min(2, "Name must be at least 2 characters"),
});

const updatePasswordSchema = z
  .object({
    oldPassword: z.string().min(1, "oldPassword is required"),
    newPassword: z.string().min(8, "newPassword must be at least 8 characters"),
  })
  .refine((data) => data.oldPassword !== data.newPassword, {
    message: "newPassword must be different from oldPassword",
    path: ["newPassword"],
  });

const updatePreferencesSchema = z.object({
  requiresHalal: z.boolean(),
  requiresVegan: z.boolean(),
  allergies: z.array(z.string().trim().min(1, "Allergy values cannot be empty")),
});

function validationErrorResponse(error: z.ZodError) {
  return error.issues.map((issue) => ({
    field: issue.path.join("."),
    message: issue.message,
  }));
}

export const changeUsername = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const parsedBody = updateNameSchema.safeParse(req.body);
    if (!parsedBody.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedBody.error),
      });
      return;
    }

    const { name } = parsedBody.data;

    const user = await findUserById(userId);
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    const updatedUser = await updateUsername(userId, name);

    res.status(200).json({
      message: "Username updated successfully",
      user: {
        id: updatedUser.id,
        name: updatedUser.name,
      },
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const changePassword = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const parsedBody = updatePasswordSchema.safeParse(req.body);
    if (!parsedBody.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedBody.error),
      });
      return;
    }

    const { oldPassword, newPassword } = parsedBody.data;

    const user = await findUserById(userId);

    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      res.status(400).json({ error: "Invalid old password" });
      return;
    }

    const hashedNewPassword = await bcrypt.hash(newPassword, 10);
    const updatedUser = await updatePassword(userId, hashedNewPassword);

    res.status(200).json({
      message: "Password updated successfully",
      user: {
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
      },
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const updateUserPreferences = async (
  req: AuthRequest,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const parsedBody = updatePreferencesSchema.safeParse(req.body);
    if (!parsedBody.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedBody.error),
      });
      return;
    }

    const { requiresHalal, requiresVegan, allergies } = parsedBody.data;

    const user = await findUserById(userId);

    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    const updatedUser = await updatePreferences(
      userId,
      requiresHalal,
      requiresVegan,
      allergies,
    );
    res.status(200).json({
      message: "User preferences updated successfully",
      user: {
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
        hasCompletedOnboarding: updatedUser.hasCompletedOnboarding,
        requiresHalal: updatedUser.requiresHalal,
        requiresVegan: updatedUser.requiresVegan,
        allergies: updatedUser.allergies,
      },
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
