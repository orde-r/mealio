import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static Future<Map<String, dynamic>> getFavorites() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.get(

      Uri.parse(
        'http://localhost:3000/api/user/favorites',
      ),

      headers: {

        "Authorization": "Bearer $token",

      },

    );

    return {

      "statusCode": response.statusCode,

      "data": jsonDecode(response.body),

    };

  }

  static Future<Map<String, dynamic>> addFavorite(String restaurantId) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.post(

      Uri.parse(
        'http://localhost:3000/api/user/favorites/$restaurantId',
      ),

      headers: {

        "Authorization": "Bearer $token",

      },

    );

    return {

      "statusCode": response.statusCode,

      "data": jsonDecode(response.body),

    };

  }

  static Future<Map<String, dynamic>> removeFavorite(String restaurantId) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.delete(

      Uri.parse(
        'http://localhost:3000/api/user/favorites/$restaurantId',
      ),

      headers: {

        "Authorization": "Bearer $token",

      },

    );

    return {

      "statusCode": response.statusCode,

      "data": jsonDecode(response.body),

    };

  }

}