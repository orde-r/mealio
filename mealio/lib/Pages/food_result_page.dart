import 'package:flutter/material.dart';
import 'package:mealio/Services/favorites_service.dart';
import 'package:mealio/Services/food_service.dart';
import 'package:mealio/models/restaurant_model.dart';
import 'package:mealio/widgets/restaurant_card.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
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
            (a, b) => a.startingPrice.compareTo(b.startingPrice));
      } else if (type == "Distance") {
        restaurantList.sort(
            (a, b) => a.distanceKm.compareTo(b.distanceKm));
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF26A3D) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF26A3D)
                : const Color(0xFFE2E8F0),
          ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Top Picks",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text("Sort by",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
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
              Text(
                restaurantList.length > 1
                    ? '${restaurantList.length} Matches'
                    : '${restaurantList.length} Match',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: restaurantList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        children: restaurantList
                            .map((r) => RestaurantCard(
                                  restaurant: r,
                                  isFavorited: favoritedIds.contains(r.id),
                                  onFavoriteToggle: () => _toggleFavorite(r),
                                ))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
