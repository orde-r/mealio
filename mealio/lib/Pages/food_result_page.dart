import 'package:flutter/material.dart';
import 'package:mealio/Services/favorites_service.dart';
import 'package:mealio/Services/food_service.dart';
import 'package:mealio/models/restaurant_model.dart';
import 'package:mealio/widgets/restaurant_card.dart';
import 'package:mealio/theme/mealio_theme.dart';

class FoodResultPage extends StatefulWidget {
  final double radius;
  final int minPrice;
  final int maxPrice;
  final String mood;

  const FoodResultPage({
    super.key,
    required this.radius,
    required this.minPrice,
    required this.maxPrice,
    required this.mood,
  });

  @override
  State<FoodResultPage> createState() => _FoodResultState();
}

class _FoodResultState extends State<FoodResultPage> {
  List<RestaurantModel> restaurantList = [];
  final Set<String> favoritedIds = {};
  String selectedSort = "Relevance";
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final results = await Future.wait([
        FoodService.getRecommendations(
          mood: widget.mood,
          minPrice: widget.minPrice,
          maxPrice: widget.maxPrice,
          radius: widget.radius,
        ),
        FavoritesService.getFavorites(),
      ]);
      if (!mounted) return;

      restaurantList = results[0] as List<RestaurantModel>;

      final favResult = results[1] as Map<String, dynamic>;
      if (favResult['statusCode'] == 200) {
        final favorites = favResult['data'] as List<dynamic>? ?? [];
        favoritedIds.addAll(favorites.map((f) => f['id'].toString()));
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _toggleFavorite(RestaurantModel restaurant) async {
    final id = restaurant.id;
    final isFav = favoritedIds.contains(id);

    setState(() {
      if (isFav) {
        favoritedIds.remove(id);
      } else {
        favoritedIds.add(id);
      }
    });

    try {
      if (isFav) {
        await FavoritesService.removeFavorite(id);
      } else {
        await FavoritesService.addFavorite(id);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (isFav) {
          favoritedIds.add(id);
        } else {
          favoritedIds.remove(id);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update favorite")),
      );
    }
  }

  void sortRestaurants(String type) {
    setState(() {
      selectedSort = type;
      if (type == "Rating") {
        restaurantList.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (type == "Price") {
        restaurantList.sort(
          (a, b) => a.startingPrice.compareTo(b.startingPrice),
        );
      } else if (type == "Distance") {
        restaurantList.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      } else if (type == "Relevance") {
        restaurantList.sort((a, b) {
          final aScore = a.aiScore ?? 0;
          final bScore = b.aiScore ?? 0;
          if (aScore != bScore) return bScore.compareTo(aScore);
          return a.distanceKm.compareTo(b.distanceKm);
        });
      }
    });
  }

  Widget _sortChip(String label) {
    final isSelected = selectedSort == label;
    return GestureDetector(
      onTap: () => sortRestaurants(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? MealioColors.primary : MealioColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? MealioColors.primary : MealioColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MealioColors.primary.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Top Picks')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Sort by',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MealioColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _sortChip("Relevance"),
                      _sortChip("Distance"),
                      _sortChip("Rating"),
                      _sortChip("Price"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  restaurantList.length == 1
                      ? '1 match found'
                      : '${restaurantList.length} matches found',
                  style: textTheme.labelLarge?.copyWith(
                    color: MealioColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? _buildStatusState(
                        context,
                        icon: Icons.error_outline,
                        title: 'Could not load results',
                        subtitle: _errorMessage!,
                        actionLabel: 'Try again',
                        onAction: _loadData,
                      )
                    : restaurantList.isEmpty
                    ? _buildStatusState(
                        context,
                        icon: Icons.ramen_dining_outlined,
                        title: 'No matches found',
                        subtitle:
                            'Try widening the price range or increasing the search radius.',
                      )
                    : ListView(
                        children: restaurantList
                            .map(
                              (r) => RestaurantCard(
                                restaurant: r,
                                isFavorited: favoritedIds.contains(r.id),
                                onFavoriteToggle: () => _toggleFavorite(r),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
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
