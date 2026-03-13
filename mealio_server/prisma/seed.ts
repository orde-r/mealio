import prisma from "../src/prisma";

async function main() {
  console.log("Adding restaurant data into the list");

  await prisma.restaurant.createMany({
    data: [
      {
        name: "Sate Ayam BSD",
        address: "Jl. Pahlawan Seribu, BSD City, Tangerang",
        latitude: -6.2793,
        longitude: 106.6648,
        isHalal: true,
        isVegan: false,
        startingPrice: 25000,
        rating: 4.8,
        ratingCount: 320,
        tags: ["Indonesian", "Street Food", "Meat", "Dinner"],
        signatureDishes: ["Sate Ayam Madura", "Lontong", "Es Teh Manis"],
      },
      {
        name: "Green Bowl Alam Sutera",
        address: "Flavor Bliss, Alam Sutera, Tangerang",
        latitude: -6.2381,
        longitude: 106.6533,
        isHalal: true,
        isVegan: true,
        startingPrice: 55000,
        rating: 4.6,
        ratingCount: 145,
        tags: ["Vegan", "Healthy", "Salad", "Cafe"],
        signatureDishes: [
          "Quinoa Salad Bowl",
          "Vegan Burger",
          "Oat Milk Matcha",
        ],
      },
      {
        name: "Mie Pedas Gila Gading Serpong",
        address: "Ruko Gading Serpong, Tangerang",
        latitude: -6.2415,
        longitude: 106.6281,
        isHalal: false,
        isVegan: false,
        startingPrice: 30000,
        rating: 4.2,
        ratingCount: 890,
        tags: ["Noodles", "Spicy", "Asian", "Late Night"],
        signatureDishes: ["Mie Pedas Level 5", "Pangsit Goreng", "Es Jeruk"],
      },
    ],
    skipDuplicates: true,
  });

  console.log("Restaurant added to list");
}

main()
  .catch((e) => {
    console.error("Error seeding the database", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
