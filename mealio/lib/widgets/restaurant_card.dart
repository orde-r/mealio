import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mealio/models/restaurant_model.dart';
import 'package:mealio/theme/mealio_theme.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool isFavorited;
  final VoidCallback? onFavoriteToggle;
  final bool showDistance;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.isFavorited = false,
    this.onFavoriteToggle,
    this.showDistance = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _openMap(context),
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: MealioColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MealioColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
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
                            errorBuilder: (context, error, stackTrace) {
                              return _imagePlaceholder();
                            },
                          )
                        : _imagePlaceholder(),
                  ),
                  if (showDistance)
                    Positioned(
                      left: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: MealioColors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${restaurant.distanceKm.toStringAsFixed(1)} km away',
                          style: textTheme.labelMedium?.copyWith(
                            color: MealioColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
                          decoration: BoxDecoration(
                            color: MealioColors.surface.withValues(alpha: 0.96),
                            shape: BoxShape.circle,
                            border: Border.all(color: MealioColors.border),
                          ),
                          child: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: MealioColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 24,
                        color: MealioColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.tags.join(' • '),
                      style: textTheme.bodyMedium?.copyWith(
                        color: MealioColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaPill(
                          icon: Icons.star_rounded,
                          label: restaurant.rating.toString(),
                          iconColor: Colors.amber.shade700,
                          backgroundColor: Colors.amber.withValues(alpha: 0.12),
                        ),
                        if (restaurant.aiScore != null)
                          _MetaPill(
                            icon: Icons.auto_awesome,
                            label: '${restaurant.aiScore!.toInt()}% match',
                            iconColor: MealioColors.accent,
                            backgroundColor: MealioColors.accent.withValues(
                              alpha: 0.10,
                            ),
                          ),
                        _MetaPill(
                          icon: Icons.payments_outlined,
                          label: 'From ${restaurant.startingPrice ~/ 1000}k',
                          iconColor: MealioColors.primary,
                          backgroundColor: MealioColors.primary.withValues(
                            alpha: 0.10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMap(BuildContext context) async {
    final url = Uri.parse(restaurant.locationUrl);
    print(url);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map link')),
        );
      }
    }
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

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;

  const _MetaPill({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: MealioColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
