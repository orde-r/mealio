import "dotenv/config";
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { createUser, findExistingUser } from "../repository/userRepository";

const registerSchema = z.object({
  name: z.string().trim().min(2, "Name must be at least 2 characters"),
  email: z.string().trim().email("Invalid email format"),
  password: z.string().min(8, "Password must be at least 8 characters"),
});

const loginSchema = z.object({
  email: z.string().trim().email("Invalid email format"),
  password: z.string().min(1, "Password is required"),
});

function validationErrorResponse(error: z.ZodError) {
  return error.issues.map((issue) => ({
    field: issue.path.join("."),
    message: issue.message,
  }));
}

export const registerUser = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const parsedBody = registerSchema.safeParse(req.body);
    if (!parsedBody.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedBody.error),
      });
      return;
    }

    const { name, email, password } = parsedBody.data;

    const existingUser = await findExistingUser(email);

    if (existingUser) {
      res.status(409).json({ error: "Email is already in use." });
      return;
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await createUser({ email, password: hashedPassword, name });

    res.status(201).json({
      message: "User registered successfully",
      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const loginUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const parsedBody = loginSchema.safeParse(req.body);
    if (!parsedBody.success) {
      res.status(400).json({
        error: "Validation failed",
        details: validationErrorResponse(parsedBody.error),
      });
      return;
    }

    const { email, password } = parsedBody.data;

    const user = await findExistingUser(email);
    
    if (!user) {
      res.status(401).json({
        error: "Invalid Credentials",
      });
      return;
    }

    const authUser = await bcrypt.compare(password, user.password);
    if (!authUser) {
      res.status(401).json({ error: "Invalid Credentials" });
      return;
    }

    const jwtSecret = process.env.JWT_SECRET;
    if (!jwtSecret) {
      res.status(500).json({ error: "JWT_SECRET is not configured" });
      return;
    }

    const token = jwt.sign({ userId: user.id }, jwtSecret, {
      expiresIn: "14d",
    });

    res.status(200).json({
      message: "Login successful",
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        hasCompletedOnboarding: user.hasCompletedOnboarding
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

