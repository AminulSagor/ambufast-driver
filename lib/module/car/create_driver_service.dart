// lib/combine_service/create_driver_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class CreateDriverService {
  CreateDriverService({
    String? baseUrl,
    http.Client? client,
    this.authToken,
  })  : _base = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? '').trim(),
        _client = client ?? http.Client() {
    if (_base.isEmpty) {
      throw ApiException('API_BASE_URL is missing from .env');
    }
  }

  final String _base;
  final http.Client _client;

  /// Optional: add a bearer token if your API requires auth
  final String? authToken;

  static const _maxMulti = 5;

  /// Creates a driver and returns the decoded JSON response from the API.
  /// If the server returns non-JSON, it will be wrapped under {"raw": "<body>"}.
  Future<Map<String, dynamic>> createDriver({
    // ---- simple text fields ----
    required String ext,
    String? phone,
    String? email,
    required String fullname,
    required String dobIso, // e.g. 1997-10-10T00:00:00.000Z
    required String gender, // MALE/FEMALE/OTHER
    required String bloodgroup, // e.g. B+
    required String password,

    // ---- nested json fields ----
    required Map<String, dynamic> address,
    required Map<String, dynamic> rider,
    required Map<String, dynamic> vehicle, // includes additionalServices: []

    // ---- single-file fields ----
    String? profilePhotoPath,
    String? licenseFrontPath,
    String? licenseBackPath,

    // ---- multi-file fields (<= 5 each) ----
    List<String> vehiclePhotos = const [],
    List<String> vehicleStickerPhotos = const [],
    List<String> vehicleInsurancePhotos = const [],
  }) async {
    // defensive caps (UI should already ensure this)
    void _checkLen(String label, List<String> paths) {
      if (paths.length > _maxMulti) {
        throw ApiException('$label cannot have more than $_maxMulti photos');
      }
    }

    _checkLen('vehicle_photos', vehiclePhotos);
    _checkLen('vehicle_sticker', vehicleStickerPhotos);
    _checkLen('vehicle_insurance', vehicleInsurancePhotos);

    final uri = Uri.parse('$_base/v1/user/create-driver');
    final req = http.MultipartRequest('POST', uri);

    // headers
    req.headers['Accept'] = 'application/json';
    if (authToken != null && authToken!.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $authToken';
    }

    // fields
    req.fields.addAll({
      'ext': ext,
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone!.trim(),
      if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      'fullname': fullname.trim(),
      'dob': dobIso,
      'gender': gender,
      'bloodgroup': bloodgroup,
      'password': password,
      'address': jsonEncode(address),
      'rider': jsonEncode(rider),
      'vehicle': jsonEncode(vehicle),
    });

    // single-file helpers
    Future<void> _addOne(String name, String? path) async {
      if (path == null || path.isEmpty) return;
      req.files.add(await http.MultipartFile.fromPath(name, path));
    }

    await _addOne('profile_photo', profilePhotoPath);
    await _addOne('license_front', licenseFrontPath);
    await _addOne('license_back', licenseBackPath);

    // multi-file helper (repeat field name)
    Future<void> _addMany(String name, List<String> paths) async {
      for (final p in paths.take(_maxMulti)) {
        req.files.add(await http.MultipartFile.fromPath(name, p));
      }
    }

    await _addMany('vehicle_photos', vehiclePhotos);
    await _addMany('vehicle_sticker', vehicleStickerPhotos);
    await _addMany('vehicle_insurance', vehicleInsurancePhotos);

    // send and build a normal Response
    final streamed = await _client.send(req);
    final res = await http.Response.fromStream(streamed);

    // parse helper
    Map<String, dynamic> _safeDecode(String body) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) return decoded;
        // Wrap non-map JSON (e.g., list/primitive) so caller still gets it
        return {'data': decoded};
      } catch (_) {
        return {'raw': body};
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (kDebugMode) {
        // visible in debug only
        print('✅ [CreateDriver] ${res.statusCode}: ${res.body}');
      }
      return _safeDecode(res.body);
    }

    // error path: try to surface server message/body
    final decoded = _safeDecode(res.body);
    final msg = (decoded['message']?.toString() ??
        decoded['error']?.toString() ??
        'Request failed');

    if (kDebugMode) {
      print('❌ [CreateDriver] ${res.statusCode}: ${res.body}');
    }

    throw ApiException(
      msg,
      statusCode: res.statusCode,
      data: decoded,
    );
  }

  void dispose() {
    _client.close();
  }
}
