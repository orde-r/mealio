import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mealino/Models/restaurant_model.dart';

class FoodService {

  static const String baseUrl =
      "http://10.0.2.2:8080";

  static Future<List<RestaurantModel>>
      getRecommendations({

    required String mood,
    required int minPrice,
    required int maxPrice,
    required double radius,

  }) async {

    final response = await http.post(

      Uri.parse(
        'http://localhost:3000/api/food/recommend',
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "mood": mood,

        "minPrice": minPrice * 1000,
        "maxPrice": maxPrice * 1000,

        "radius": radius,
      }),
    );

    final data = jsonDecode(response.body);

    final candidates = data["candidates"];

    return List<RestaurantModel>.from(

      candidates.map(
        (x) => RestaurantModel.fromJson(x),
      ),
    );
  }
}