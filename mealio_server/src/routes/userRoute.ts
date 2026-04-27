import { Router } from "express";

import {
	changePassword,
	changeUsername,
	getUserPreferences,
	patchUserOnboarding,
	updateUserPreferences,
} from "../controllers/userController";
import { protectRoute } from "../middleware/authMiddleware";

const router = Router();

router.get("/preferences", protectRoute, getUserPreferences);
router.put("/password", protectRoute, changePassword);
router.put("/name", protectRoute, changeUsername);
router.put("/preferences", protectRoute, updateUserPreferences);
router.patch("/onboarding", protectRoute, patchUserOnboarding);

export {router as userRouter};