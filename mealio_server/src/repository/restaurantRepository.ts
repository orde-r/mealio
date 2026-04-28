import prisma from "../prisma";

export type RecommendationCandidate = {
  id: string;
  name: string;
  address: string;
  latitude: number;
  longitude: number;
  locationUrl: string | null;
  isHalal: boolean;
  isVegan: boolean;
  startingPrice: number;
  rating: number;
  ratingCount: number;
  tags: string[] | null;
  signatureDishes: string[] | null;
  imageUrl: string | null;
  distanceKm: number;
};

export function findRestaurantById(id: string) {
  const restaurant = prisma.restaurant.findUnique({
    where: { id },
  });
  return restaurant;
}

function normalizeValue(value: string) {
  return value.trim().toLowerCase();
}

function calculateDistanceKm(
  originLatitude: number,
  originLongitude: number,
  destinationLatitude: number,
  destinationLongitude: number,
) {
  const earthRadiusKm = 6371;
  const deltaLatitude =
    ((destinationLatitude - originLatitude) * Math.PI) / 180;
  const deltaLongitude =
    ((destinationLongitude - originLongitude) * Math.PI) / 180;
  const startLatitude = (originLatitude * Math.PI) / 180;
  const endLatitude = (destinationLatitude * Math.PI) / 180;

  const a =
    Math.sin(deltaLatitude / 2) ** 2 +
    Math.cos(startLatitude) *
      Math.cos(endLatitude) *
      Math.sin(deltaLongitude / 2) ** 2;

  return earthRadiusKm * 2 * Math.asin(Math.min(1, Math.sqrt(a)));
}

export async function findRecommendedRestaurants(params: {
  latitude: number;
  longitude: number;
  radiusKm: number;
  maxStartingPrice: number;
  requiresHalal: boolean;
  requiresVegan: boolean;
  allergies: string[];
}): Promise<RecommendationCandidate[]> {
  const {
    latitude,
    longitude,
    radiusKm,
    maxStartingPrice,
    requiresHalal,
    requiresVegan,
    allergies,
  } = params;

  const restaurants = await prisma.restaurant.findMany({
    where: {
      startingPrice: {
        lte: maxStartingPrice,
      },
      ...(requiresHalal ? { isHalal: true } : {}),
      ...(requiresVegan ? { isVegan: true } : {}),
    },
    select: {
      id: true,
      name: true,
      address: true,
      latitude: true,
      longitude: true,
      locationUrl: true,
      isHalal: true,
      isVegan: true,
      startingPrice: true,
      rating: true,
      ratingCount: true,
      tags: true,
      signatureDishes: true,
      imageUrl: true,
    },
  });

  const allergySet = new Set(allergies.map(normalizeValue));

  const candidates = restaurants
    .filter((restaurant) => {
      if (allergySet.size === 0) {
        return true;
      }

      const hasConflict = (values: string[] | null) => {
        if (!values || values.length === 0) {
          return false;
        }

        return values.some((value) => allergySet.has(normalizeValue(value)));
      };

      return (
        !hasConflict(restaurant.tags) &&
        !hasConflict(restaurant.signatureDishes)
      );
    })
    .map((restaurant) => ({
      ...restaurant,
      distanceKm: calculateDistanceKm(
        latitude,
        longitude,
        restaurant.latitude,
        restaurant.longitude,
      ),
    }))
    .filter((restaurant) => restaurant.distanceKm <= radiusKm)
    .sort((left, right) => left.distanceKm - right.distanceKm);

  return candidates;
}
