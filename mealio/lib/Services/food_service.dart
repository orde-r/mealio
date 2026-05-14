import 'package:geolocator/geolocator.dart';
import 'package:mealio/Services/api_client.dart';
import 'package:mealio/models/restaurant_model.dart';

class FoodService {
  static Future<Position> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // print('[FoodService] Location service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        // print('[FoodService] Using fallback coordinates (GPS disabled)');
        return _fallbackPosition();
      }

      final hasPermission = await Geolocator.checkPermission();
      // print('[FoodService] Location permission: $hasPermission');
      if (hasPermission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 3),
        ),
      ).timeout(const Duration(seconds: 5));

      // print('[FoodService] Got GPS: ${position.latitude}, ${position.longitude}');

      // Seed data is in Jakarta (-6.x); if GPS is outside Indonesia, fall back
      if (position.latitude > 0) {
        // print('[FoodService] GPS outside Indonesia, falling back to Jakarta');
        return _fallbackPosition();
      }
      return position;
    } catch (e) {
      // print('[FoodService] GPS failed: $e');
      // print('[FoodService] Using fallback coordinates (Jakarta)');
      return _fallbackPosition();
    }
  }

  static Position _fallbackPosition() {
    return Position(
      latitude: -6.2088,
      longitude: 106.8456,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  static Future<List<RestaurantModel>> getRecommendations({
    required String mood,
    required int minPrice,
    required int maxPrice,
    required double radius,
  }) async {
    final position = await getCurrentPosition();

    final body = <String, dynamic>{
      'latitude': position.latitude,
      'longitude': position.longitude,
      'radiusKm': radius,
      'mood': mood,
    };

    if (minPrice > 0) {
      body['minStartingPrice'] = minPrice * 1000;
    }
    if (maxPrice > 0) {
      body['maxStartingPrice'] = maxPrice * 1000;
    }

    // print('[FoodService] Request body: $body');

    final result = await ApiClient.post('/api/food/recommend', body, auth: true);

    // print('[FoodService] Response status: ${result['statusCode']}');
    // print('[FoodService] Response data: ${result['data']}');

    if (result['statusCode'] != 200) {
      final data = result['data'];
      final error = data?['error'] ?? 'Unknown error';
      throw Exception('$error (${result['statusCode']})');
    }

    final candidates = result['data']['candidates'];
    // print('[FoodService] Got ${candidates.length} candidates');
    return List<RestaurantModel>.from(
      candidates.map((x) => RestaurantModel.fromJson(x)),
    );
  }
}
