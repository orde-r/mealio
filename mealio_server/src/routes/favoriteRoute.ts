import { Router } from "express";
import {
  addFavoriteRestaurant,
  deleteFavoriteRestaurant,
  getFavoriteRestaurants,
} from "../controllers/favoriteController";
import { protectRoute } from "../middleware/authMiddleware";

const router = Router();

router.post("/:restaurantId", protectRoute, addFavoriteRestaurant);
router.delete("/:restaurantId", protectRoute, deleteFavoriteRestaurant);
router.get("/", protectRoute, getFavoriteRestaurants);

export { router as favoriteRouter };
