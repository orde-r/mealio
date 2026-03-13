import prisma from "../prisma";

export function findRestaurantById(id: string) {
  const restaurant = prisma.restaurant.findUnique({
    where: { id },
  });
  return restaurant;
}
