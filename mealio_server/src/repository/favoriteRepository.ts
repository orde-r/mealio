import prisma from "../prisma";
import { findRestaurantById } from "./restaurantRepository";
import { findUserById } from "./userRepository";

export async function addFavorite(userId: string, restaurantId: string) {
  const user = await findUserById(userId);
  if (!user) {
    throw new Error("User not found");
  }

  const restaurant = await findRestaurantById(restaurantId);
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  const currentFavorites = await getUserFavorites(userId);
  const alreadyFavorited = currentFavorites.some(
    (favorite) => favorite.id === restaurantId,
  );

  if (alreadyFavorited) {
    return currentFavorites;
  }

  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      favorites: {
        connect: { id: restaurantId },
      },
    },
    include: { favorites: true },
  });

  return updatedUser.favorites;
}

export async function removeFavorite(userId: string, restaurantId: string) {
  const user = await findUserById(userId);
  if (!user) {
    throw new Error("User not found");
  }

  const restaurant = await findRestaurantById(restaurantId);
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  const currentFavorites = await getUserFavorites(userId);
  const alreadyRemoved = !currentFavorites.some(
    (favorite) => favorite.id === restaurantId,
  );

  if (alreadyRemoved) {
    return currentFavorites;
  }

  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      favorites: {
        disconnect: { id: restaurantId },
      },
    },
    include: { favorites: true },
  });

  return updatedUser.favorites;
}

export async function getUserFavorites(userId: string) {
  const user = await prisma.user.findUnique({
    where: {
      id: userId,
    },
    include: {
      favorites: true,
    },
  });
  if (!user) {
    throw new Error("User not found");
  }
  return user?.favorites ?? [];
}
