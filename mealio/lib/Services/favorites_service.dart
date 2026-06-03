import 'package:mealio/Services/api_client.dart';
import 'package:mealio/models/restaurant_model.dart';

class FavoritesService {
  static Future<Map<String, dynamic>> getFavorites() async {
    return ApiClient.get('/api/favorites', auth: true);
  }

  static Future<Map<String, dynamic>> addFavorite(String restaurantId) async {
    return ApiClient.post('/api/favorites/$restaurantId', {}, auth: true);
  }

  static Future<Map<String, dynamic>> removeFavorite(
    String restaurantId,
  ) async {
    return ApiClient.delete('/api/favorites/$restaurantId', auth: true);
  }

  static List<RestaurantModel> parseRestaurants(Map<String, dynamic> response) {
    return _favoriteItems(response)
        .map(_restaurantJson)
        .whereType<Map<String, dynamic>>()
        .map(RestaurantModel.fromJson)
        .toList();
  }

  static Set<String> parseRestaurantIds(Map<String, dynamic> response) {
    return _favoriteItems(
      response,
    ).map(_restaurantId).whereType<String>().toSet();
  }

  static List<dynamic> _favoriteItems(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      for (final key in ['favorites', 'restaurants', 'data']) {
        final value = data[key];
        if (value is List) return value;
      }
    }

    return const [];
  }

  static Map<String, dynamic>? _restaurantJson(dynamic item) {
    if (item is! Map<String, dynamic>) return null;

    final restaurant = item['restaurant'];
    if (restaurant is Map<String, dynamic>) {
      return restaurant;
    }

    return item;
  }

  static String? _restaurantId(dynamic item) {
    if (item is! Map<String, dynamic>) return null;

    final restaurant = item['restaurant'];
    if (restaurant is Map<String, dynamic>) {
      return restaurant['id']?.toString();
    }

    return item['restaurantId']?.toString() ?? item['id']?.toString();
  }
}
