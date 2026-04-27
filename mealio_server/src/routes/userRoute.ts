import { Router } from "express";

import { changePassword, changeUsername, updateUserPreferences } from "../controllers/userController";
import { protectRoute } from "../middleware/authMiddleware";

const router = Router();

router.put("/password", protectRoute, changePassword);
router.put("/name", protectRoute, changeUsername);
router.put("/preferences", protectRoute, updateUserPreferences);

export {router as userRouter};