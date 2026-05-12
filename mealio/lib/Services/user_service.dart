import 'package:mealio/Services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<Map<String, dynamic>> changeName({
    required String name,
  }) async {
    return ApiClient.put('/api/user/name', {'name': name}, auth: true);
  }

  static Future<Map<String, dynamic>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return ApiClient.put('/api/user/password', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    }, auth: true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, dynamic>> savePreferences({
    required bool halal,
    required bool vegan,
    required List<String> allergies,
  }) async {
    return ApiClient.put('/api/user/preferences', {
      'requiresHalal': halal,
      'requiresVegan': vegan,
      'allergies': allergies,
      'hasCompletedOnboarding': true,
    }, auth: true);
  }

  static Future<Map<String, dynamic>> getPreferences() async {
    return ApiClient.get('/api/user/preferences', auth: true);
  }
}
