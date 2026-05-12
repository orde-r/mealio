import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {

  static Future<Map<String, dynamic>> register({

    required String name,
    required String email,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse(
        'http://localhost:3000/api/auth/register',
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "name": name,
        "email": email,
        "password": password,

      }),

    );

    return {

      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),

    };

  }

  static Future<Map<String, dynamic>> login({

    required String email,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse(
        'http://localhost:3000/api/auth/login',
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "email": email,
        "password": password,

      }),

    );

    final data = jsonDecode(response.body);

    if(response.statusCode == 200){

      final prefs = await SharedPreferences.getInstance();

      prefs.setString(
        "token",
        data["token"],
      );

      prefs.setString(
        "name",
        data["user"]["name"],
      );

      prefs.setString(
        "email",
        data["user"]["email"],
      );

    }

    return {

      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),

    };

  }

}