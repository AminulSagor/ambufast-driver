// lib/combine_service/add_vehicle_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../network/token_http_client.dart';



class AddVehicleService {
  final String _base;
  final http.Client _client;

  AddVehicleService({String? baseUrl, http.Client? client})
      : _base = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? '').trim(),
        _client = client ?? TokenHttpClient() {
    if (_base.isEmpty) {
      throw Exception('API_BASE_URL is missing from .env');
    }
  }

  /// PATCH /v1/user/profile/update-user-info
  /// Body: { "addNewVehicle": { ...vehicle payload... } }
  Future<Map<String, dynamic>> addNewVehicle(Map<String, dynamic> vehicle) async {
    final uri = Uri.parse('$_base/v1/user/profile/update-user-info');

    final res = await _client.patch(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'addNewVehicle': vehicle}),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    print('❌ Add vehicle failed (${res.statusCode}): ${res.body}');
    throw Exception('Add vehicle failed (${res.statusCode}): ${res.body}');
  }
}
