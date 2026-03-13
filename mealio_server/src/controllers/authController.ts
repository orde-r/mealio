import "dotenv/config";
import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import prisma from "../prisma";
import { createUser, findExistingUser } from "../repository/userRepository";

export const registerUser = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await findExistingUser(email);

    if (existingUser) {
      res.status(400).json({ error: "Email is already in use." });
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
    const { email, password } = req.body;

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

    const jwtSecret = process.env.JWT_SECRET || "mealioprojectsesunibcomscise";
    const token = jwt.sign({ userId: user.id }, jwtSecret as string, {
      expiresIn: "14d",
    });

    res.status(200).json({
      message: "Authorized Access",
      token: token,
      customer: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

