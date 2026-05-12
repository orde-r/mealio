import 'package:mealio/Services/api_client.dart';

class FavoritesService {
  static Future<Map<String, dynamic>> getFavorites() async {
    return ApiClient.get('/api/favorites', auth: true);
  }

  static Future<Map<String, dynamic>> addFavorite(String restaurantId) async {
    return ApiClient.post('/api/favorites/$restaurantId', {}, auth: true);
  }

  static Future<Map<String, dynamic>> removeFavorite(String restaurantId) async {
    return ApiClient.delete('/api/favorites/$restaurantId', auth: true);
  }
}
