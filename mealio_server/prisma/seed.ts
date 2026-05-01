import { readFile } from "fs/promises";
import path from "path";
import type { Prisma } from "@prisma/client";
import prisma from "../src/prisma";

type SeedRestaurant = Prisma.RestaurantCreateManyInput;

async function loadRestaurantData(): Promise<SeedRestaurant[]> {
  const seedFilePath = path.resolve(__dirname, "restaurants.json");
  const fileContents = await readFile(seedFilePath, "utf8");

  return JSON.parse(fileContents) as SeedRestaurant[];
}

async function main() {
  const restaurantData = await loadRestaurantData();

  console.log(
    `Adding ${restaurantData.length} restaurant records from restaurants.json`,
  );

  await prisma.restaurant.createMany({
    data: restaurantData,
    skipDuplicates: true,
  });

  console.log("Restaurant data added to list");
}

main()
  .catch((e) => {
    console.error("Error seeding the database", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
