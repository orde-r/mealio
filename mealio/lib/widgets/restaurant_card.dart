import 'package:flutter/material.dart';

import 'package:mealio/models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool isFavorited;
  final VoidCallback? onFavoriteToggle;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.isFavorited = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: restaurant.imageUrl.isNotEmpty
                    ? Image.network(
                        restaurant.imageUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
              if (onFavoriteToggle != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFF26A3D),
                        size: 22,
                      ),
                    ),
                  ),
                ),
            ],
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
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(restaurant.rating.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15,
                      ),
                    ),
                    if (restaurant.aiScore != null) ...[
                      const Text("•",
                          style: TextStyle(color: Color(0xFF94A3B8))),
                      const Icon(Icons.auto_awesome,
                          color: Color(0xFF8B5CF6), size: 16),
                      Text("${restaurant.aiScore!.toInt()}% match",
                        style: const TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                        ),
                      ),
                    ],
                    const Text("•",
                        style: TextStyle(color: Color(0xFF94A3B8))),
                    Text("From ${restaurant.startingPrice ~/ 1000}k",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    const Text("•",
                        style: TextStyle(color: Color(0xFF94A3B8))),
                    Text("${restaurant.distanceKm.toStringAsFixed(1)} km",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    final placeholders = [
      'assets/placeholder1.png',
      'assets/placeholder2.png',
      'assets/placeholder3.png',
    ];
    final index = restaurant.name.hashCode.abs() % placeholders.length;

    return Image.asset(
      placeholders[index],
      height: 240,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
