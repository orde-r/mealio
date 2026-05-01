import { Router } from "express";
import { recommendRestaurants } from "../controllers/foodController";
import { protectRoute } from "../middleware/authMiddleware";

const router = Router();

router.post("/recommend", protectRoute, recommendRestaurants);

export { router as foodRouter };
