// lib/services/token_auth_service.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/token_storage.dart';

class TokenAuthService {
  static Future<bool> refreshAccessToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final uri = Uri.parse('$baseUrl/v1/auth/refresh-token');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['access_token'];
        final newRefresh = data['refresh_token'];
        if (newAccess != null && newRefresh != null) {
          await TokenStorage.saveTokens(newAccess, newRefresh);
          return true;
        }
      }
    } catch (e) {
      // Optional: log error or track with Sentry
    }

    await TokenStorage.clearTokens();
    Get.offAllNamed('/login', arguments: {'intent': 'login'});// fallback: ensure user gets logged out on refresh failure
    return false;
  }
}
