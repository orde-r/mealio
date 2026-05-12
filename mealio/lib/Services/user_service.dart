import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static Future<Map<String, dynamic>> changeName({
    required String name,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.put(

      Uri.parse(
          'http://localhost:3000/api/user/name',
        ),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode({
        "name": name,
      }),

    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> updatePassword({

    required String oldPassword,
    required String newPassword,

  }) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.put(

      Uri.parse(
        'http://localhost:3000/api/user/password',
      ),
      

      headers: {

        "Content-Type": "application/json",

        "Authorization": "Bearer $token",

      },

      

      body: jsonEncode({

        "oldPassword": oldPassword,

        "newPassword": newPassword,

      }),

    );

    return {

      "statusCode": response.statusCode,

      "data": jsonDecode(response.body),

    };

  }

  static Future<void> logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

  }

  static Future<Map<String, dynamic>> savePreferences({
    required bool halal,
    required bool vegan,
    required List<String> allergies,

  }) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.put(
      
      Uri.parse(
        'http://localhost:3000/api/user/preferences',
      ),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },

      body: jsonEncode({
        "requiresHalal": halal,
        "requiresVegan": vegan,
        "allergies": allergies,
        "hasCompletedOnboarding": true

      }),

    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> getPreferences() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    final response = await http.get(

      Uri.parse(
        'http://localhost:3000/api/user/preferences',
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