import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:http/http.dart' as http;

import '../../storage/token_storage.dart';


class ProfileService {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-ambufast-v2.taldev.xyz',
  );

  static Future<Map<String, dynamic>> getUserInfo() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('No access token');
    }

    final url = Uri.parse(
      '$_baseUrl/v1/user/profile/get-user-info'
          '?profile=true&address=true&riderinfo=false&vehicleinfo=false&agentinfo=false',
    );

    // --- request ---
    if (kDebugMode) {
      dev.log('GET $url', name: 'ProfileService');
    }

    final resp = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // do NOT print this
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 20));


    if (kDebugMode) {
      dev.log(
        'Status: ${resp.statusCode}\n'
            'Body (raw): ${resp.body}',
        name: 'ProfileService',
      );
    }

    // decode once and pretty print JSON (debug only)
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(resp.body) as Map<String, dynamic>;
      if (kDebugMode) {
        final pretty = const JsonEncoder.withIndent('  ').convert(decoded);
        dev.log('Body (pretty):\n$pretty', name: 'ProfileService');
      }
    } catch (e) {
      // If server returns non-JSON, still surface a helpful error
      throw Exception('Non-JSON response (${resp.statusCode}): ${resp.body}');
    }

    if (resp.statusCode == 200) {
      return decoded;
    } else {
      // include a compact JSON preview for errors
      throw Exception('Failed to load profile: ${resp.statusCode} ${resp.body}');
    }
  }
}
