import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

export interface AuthRequest extends Request {
  userId?: string;
}

export const protectRoute = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
): void => {
  try {
    const authHeader = req.header("Authorization");

    if (!authHeader) {
      res.status(401).json({ error: "Access denied, no token provided" });
      return;
    }

    const token = authHeader

    const secret = process.env.JWT_SECRET || "fallback_secret";

    const decoded = jwt.verify(token, secret) as { userId: string };

    req.userId = decoded.userId;

    next();
  } catch (error) {
    res.status(401).json({ error: "invalid or expired token" });
  }
};
