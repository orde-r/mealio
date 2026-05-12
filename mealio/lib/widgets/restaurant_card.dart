import 'package:flutter/material.dart';

import 'package:mealino/Models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),

            child: Image.network(
              restaurant.imageUrl,

              height: 240,
              width: double.infinity,

              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  restaurant.name,

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  restaurant.tags.join(" • "),

                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),

                    const SizedBox(width: 5),

                    Text(restaurant.rating.toString()),

                    const SizedBox(width: 15),

                    Text("From ${restaurant.startingPrice ~/ 1000}k"),

                    const SizedBox(width: 15),

                    Text("•", style: TextStyle(color: Colors.grey.shade400)),

                    const SizedBox(width: 15),

                    Text("${restaurant.distanceKm.toStringAsFixed(1)} km"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
