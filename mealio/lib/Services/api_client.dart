import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String get _baseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url != null) return url;

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool auth = false,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(auth: auth),
    );
    return {
      'statusCode': response.statusCode,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return {
      'statusCode': response.statusCode,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return {
      'statusCode': response.statusCode,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool auth = false,
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(auth: auth),
    );
    return {
      'statusCode': response.statusCode,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }
}
