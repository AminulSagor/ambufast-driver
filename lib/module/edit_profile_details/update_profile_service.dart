// lib/modules/profile_details/update_profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../network/token_http_client.dart';

/// Keep this consistent with the rest of your app/env
const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api-ambufast-v2.taldev.xyz',
);

class UpdateProfileService {
  static const _path = '/v1/user/profile/update-user-info';

  // ---------------------------
  // Public APIs
  // ---------------------------

  /// Generic updater. You can pass either/both sections.
  static Future<Map<String, dynamic>> patchProfile({
    required String authToken,
    Map<String, dynamic>? basicInfo,
    Map<String, dynamic>? addNewAddress,
  }) async {
    final uri = Uri.parse('$_baseUrl$_path');

    final payload = <String, dynamic>{};
    if (basicInfo != null && basicInfo.isNotEmpty) {
      payload['basicInfo'] = _stripNulls(basicInfo);
    }
    if (addNewAddress != null && addNewAddress.isNotEmpty) {
      payload['addNewAddress'] = _stripNulls(addNewAddress);
    }
    if (payload.isEmpty) {
      throw ArgumentError(
        'Nothing to update: both basicInfo and addNewAddress are empty.',
      );
    }

    final client = TokenHttpClient();

    final res = await client.patch(
      uri,
      headers: _headers(authToken),
      body: jsonEncode(payload),
    );
    _ensureOk(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Convenience: add a single address.
  /// Returns the newest/just-added Address from server response.
  static Future<Address> addAddress({
    required String authToken,
    required String type,
    required String street,
    String? apartment,
    required String city,
    required String state,
    required String zipcode,
    required String country,
  }) async {
    final resMap = await patchProfile(
      authToken: authToken,
      addNewAddress: {
        'type': type,
        'street': street,
        'apartment': apartment,
        'city': city,
        'state': state,
        'zipcode': zipcode,
        'country': country,
      },
    );

    final list = (resMap['data']?['user']?['addresses'] as List?) ?? const [];
    if (list.isEmpty) {
      throw StateError('Address list empty in server response.');
    }

    // Pick the newest by updatedAt (fallback createdAt).
    final newestJson = _pickNewestAddressJson(list);
    return Address.fromJson(newestJson);
  }

  // ---------------------------
  // Helpers
  // ---------------------------

  static Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static void _ensureOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Update failed (${res.statusCode}): ${res.body}');
    }
  }

  static Map<String, dynamic> _stripNulls(Map<String, dynamic> m) {
    final out = <String, dynamic>{};
    m.forEach((k, v) {
      if (v == null) return;
      if (v is String && v.trim().isEmpty) return;
      out[k] = v;
    });
    return out;
  }

  static Map<String, dynamic> _pickNewestAddressJson(List list) {
    Map<String, dynamic>? best;
    DateTime? bestTs;

    for (final e in list) {
      final m = (e as Map).cast<String, dynamic>();
      final updatedAt = _safeParseDate(m['updatedAt']);
      final createdAt = _safeParseDate(m['createdAt']);
      final ts = updatedAt ?? createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      if (best == null || ts.isAfter(bestTs!)) {
        best = m;
        bestTs = ts;
      }
    }
    return best!;
  }

  static DateTime? _safeParseDate(dynamic v) {
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }
}

/// Minimal typed model so the caller can use the newly-added address easily.
class Address {
  final String addressid;
  final String type;
  final String street;
  final String? apartment;
  final String city;
  final String state;
  final String zipcode;
  final String country;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  Address({
    required this.addressid,
    required this.type,
    required this.street,
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> j) => Address(
    addressid: (j['addressid'] ?? '').toString(),
    type: (j['type'] ?? '').toString(),
    street: (j['street'] ?? '').toString(),
    apartment: j['apartment']?.toString(),
    city: (j['city'] ?? '').toString(),
    state: (j['state'] ?? '').toString(),
    zipcode: (j['zipcode'] ?? '').toString(),
    country: (j['country'] ?? '').toString(),
    createdAt: j['createdAt'] is String ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] is String ? DateTime.tryParse(j['updatedAt']) : null,
  );
}
