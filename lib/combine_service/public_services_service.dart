import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../module/car/service_models.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class PublicServicesService {
  PublicServicesService({String? baseUrl})
      : _base = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? '').trim() {
    print('[PublicServicesService] constructed, base=$_base'); // 👈 proves ctor runs
    if (_base.isEmpty) {
      throw ApiException('API_BASE_URL is missing from .env');
    }
  }

  final String _base;

  Future<List<VehicleServiceItem>> fetchServices({
    String category = 'EMERGENCY',
    String status = 'ACTIVE',
    bool debug = true,
  }) async {
    final uri = Uri.parse('$_base/v1/public/services')
        .replace(queryParameters: {'category': category, 'status': status});

    if (debug) print('[PublicServicesService] GET $uri');

    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (debug) {
      print('[PublicServicesService] Status: ${res.statusCode}');
      print('[PublicServicesService] Body: ${res.body}');
    }

    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (map['data'] as List? ?? []);
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => VehicleServiceItem.fromJson(e))
          .toList();
    }

    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw ApiException(body['message']?.toString() ?? 'Request failed',
          statusCode: res.statusCode);
    } catch (_) {
      throw ApiException('Request failed', statusCode: res.statusCode);
    }
  }
}

