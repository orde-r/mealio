import { Router } from "express";

import { changePassword, changeUsername, updateUserPreferences } from "../controllers/userController";
import { protectRoute } from "../middleware/authMiddleware";

const router = Router();

router.post("/change-password", protectRoute, changePassword);
router.put("/change-username", protectRoute, changeUsername);
router.put("/update-preferences", protectRoute, updateUserPreferences);

export {router as userRouter};