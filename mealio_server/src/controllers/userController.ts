import { Request, Response } from "express";
import bcrypt from "bcrypt";
import { findUserById, updatePassword, updateUsername } from "../repository/userRepository";

export const changeUsername = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const { userId, newName } = req.body;

    const user = await findUserById(userId);
    if (!user) {
      res.status(401).json({ error: "User not found" });
      return;
    }

    const updatedUser = await updateUsername(userId, newName);

    res.status(200).json({
      message: "username updated successfully",
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
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const { userId, oldPassword, newPassword } = req.body;
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
