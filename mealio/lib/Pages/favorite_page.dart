import 'package:flutter/material.dart';
import 'package:mealio/Services/favorites_service.dart';
import 'package:mealio/models/restaurant_model.dart';
import 'package:mealio/widgets/restaurant_card.dart';
import 'package:mealio/theme/mealio_theme.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<RestaurantModel> restaurants = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await FavoritesService.getFavorites();

      if (!mounted) return;

      if (result['statusCode'] == 200) {
        final data = result['data'] as List<dynamic>? ?? [];
        setState(() {
          restaurants = data
              .map((j) => RestaurantModel.fromJson(j as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to load favorites right now.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load favorites right now.';
      });
    }
  }

  Future<void> _removeFavorite(RestaurantModel restaurant) async {
    setState(() {
      restaurants.removeWhere((r) => r.id == restaurant.id);
    });

    try {
      await FavoritesService.removeFavorite(restaurant.id);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Removed from favorites")));
    } catch (e) {
      if (!mounted) return;
      loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // title: const Text('Favorites'),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favorites',
                    style: textTheme.displaySmall?.copyWith(
                      fontSize: 30,
                      color: MealioColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MealioColors.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: MealioColors.border),
                    ),
                    child: Text(
                      restaurants.length == 1
                          ? '1 saved item'
                          : '${restaurants.length} saved items',
                      style: textTheme.labelLarge?.copyWith(
                        color: MealioColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? _buildEmptyState(
                        context,
                        title: 'Could not load favorites',
                        subtitle: _errorMessage!,
                        icon: Icons.favorite_border,
                        actionLabel: 'Try again',
                        onAction: loadFavorites,
                      )
                    : restaurants.isEmpty
                    ? _buildEmptyState(
                        context,
                        title: 'No favorites yet',
                        subtitle:
                            'Tap the heart on any restaurant to save it here.',
                        icon: Icons.favorite_outline,
                      )
                    : ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            isFavorited: true,
                            onFavoriteToggle: () => _removeFavorite(restaurant),
                            showDistance: false,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: MealioColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MealioColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: MealioColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: MealioColors.primary, size: 32),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontSize: 24,
                color: MealioColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: MealioColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
