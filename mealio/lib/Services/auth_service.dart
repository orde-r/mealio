import 'package:mealio/Services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return ApiClient.post('/api/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await ApiClient.post('/api/auth/login', {
      'email': email,
      'password': password,
    });

    if (result['statusCode'] == 200) {
      final data = result['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('name', data['user']['name']);
      await prefs.setString('email', data['user']['email']);
      await prefs.setBool(
        'hasCompletedOnboarding',
        data['user']['hasCompletedOnboarding'] ?? false,
      );
    }

    return result;
  }
}
