import 'package:flutter/material.dart';
import 'package:mealio/Services/favorites_service.dart';
import 'package:mealio/models/restaurant_model.dart';
import 'package:mealio/widgets/restaurant_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<RestaurantModel> restaurants = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final result = await FavoritesService.getFavorites();

      if (!mounted) return;

      if (result['statusCode'] == 200) {
        final data = result['data'] as List<dynamic>? ?? [];
        setState(() {
          restaurants = data
              .map((j) => RestaurantModel.fromJson(j as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      // silently fail
    }
  }

  Future<void> _removeFavorite(RestaurantModel restaurant) async {
    setState(() {
      restaurants.removeWhere((r) => r.id == restaurant.id);
    });

    try {
      await FavoritesService.removeFavorite(restaurant.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from favorites")),
      );
    } catch (e) {
      if (!mounted) return;
      loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Favorites",
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    restaurants.length > 1
                        ? '${restaurants.length} Items'
                        : '${restaurants.length} Item',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: restaurants.isEmpty
                    ? const Center(
                        child: Text("No favorites yet"),
                      )
                    : ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            isFavorited: true,
                            onFavoriteToggle: () =>
                                _removeFavorite(restaurant),
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
}
