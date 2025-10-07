// lib/combine_service/profile_service.dart
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../network/token_http_client.dart';

class ProfileService {
  ProfileService({
    String? baseUrl,
    http.Client? client,
  })  : _baseUrl = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? 'https://api-ambufast-v2.taldev.xyz').trim(),
        _client = client ?? TokenHttpClient() {
    if (_baseUrl.isEmpty) {
      throw Exception('API_BASE_URL is missing');
    }
  }

  final String _baseUrl;
  final http.Client _client;

  /// Fetches user info; pass which sections you need.
  Future<Map<String, dynamic>> getUserInfo({
    bool profile = true,
    bool address = true,
    bool riderinfo = false,
    bool vehicleinfo = false,
    bool agentinfo = false,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final url = Uri.parse(
      '$_baseUrl/v1/user/profile/get-user-info'
          '?profile=$profile&address=$address&riderinfo=$riderinfo&vehicleinfo=$vehicleinfo&agentinfo=$agentinfo',
    );

    if (kDebugMode) dev.log('GET $url', name: 'ProfileService');

    final resp = await _client.get(
      url,
      headers: const {'Accept': 'application/json'},
    ).timeout(timeout);

    if (kDebugMode) {
      dev.log('Status: ${resp.statusCode}', name: 'ProfileService');
      dev.log(resp.body, name: 'ProfileService');
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(resp.body) as Map<String, dynamic>;
      if (kDebugMode) {
        final pretty = const JsonEncoder.withIndent('  ').convert(decoded);
        dev.log('Pretty:\n$pretty', name: 'ProfileService');
      }
    } catch (_) {
      throw Exception('Non-JSON response (${resp.statusCode}): ${resp.body}');
    }

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return decoded;
    }
    throw Exception('Failed to load profile: ${resp.statusCode} ${resp.body}');
  }
}
