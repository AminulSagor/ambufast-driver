// lib/combine_service/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends GetConnect {
  AuthService() {
    final base = dotenv.maybeGet('API_BASE_URL')?.trim();
    httpClient.baseUrl = (base?.isNotEmpty ?? false)
        ? base
        : 'https://api-ambufast-v2.taldev.xyz';
    httpClient.timeout = const Duration(seconds: 15);
  }

  // ---------- helpers ----------
  String _errMsg(Response res, String fallback) {
    try {
      final body = res.body;
      if (body is Map && body['message'] is String && (body['message'] as String).isNotEmpty) {
        return body['message'] as String;
      }
      // some backends only return raw string
      if (res.bodyString != null && res.bodyString!.isNotEmpty) {
        return res.bodyString!;
      }
    } catch (_) {}
    return fallback;
  }

  void _ensureOk(Response res, String fallback) {
    if (res.statusCode != 200) {
      throw Exception(_errMsg(res, fallback));
    }
    if (res.body is! Map || (res.body['data'] == null)) {
      throw Exception('Unexpected response from server.');
    }
  }

  // ---------- Request OTP ----------
  Future<void> requestOtpSms({
    required String ext,
    required String phone,
  }) async {
    final res = await post(
      '/v1/auth/request-otp-sms',
      {'ext': ext, 'phone': phone},
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('requestOtpSms → status: ${res.statusCode}');
    debugPrint('requestOtpSms → body: ${res.bodyString}');
    _ensureOk(res, 'OTP request failed');
  }

  Future<void> requestOtpEmail({required String email}) async {
    final res = await post(
      '/v1/auth/request-otp-email',
      {'email': email},
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('requestOtpEmail → status: ${res.statusCode}');
    debugPrint('requestOtpEmail → body: ${res.bodyString}');
    _ensureOk(res, 'Email OTP request failed');
  }

  // ---------- Verify OTP ----------
  Future<Map<String, dynamic>> verifyOtpSms({
    required String ext,
    required String phone,
    required String otp,
  }) async {
    final res = await post(
      '/v1/auth/verify-otp-sms',
      {'ext': ext, 'phone': phone, 'otp': otp},
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('verifyOtpSms → status: ${res.statusCode}');
    debugPrint('verifyOtpSms → body: ${res.bodyString}');
    if (res.statusCode != 200) {
      throw Exception(_errMsg(res, 'OTP verification failed'));
    }
    return Map<String, dynamic>.from(res.body as Map);
  }

  Future<Map<String, dynamic>> verifyOtpEmail({
    required String email,
    required String otp,
  }) async {
    final res = await post(
      '/v1/auth/verify-otp-email',
      {'email': email, 'otp': otp},
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('verifyOtpEmail → status: ${res.statusCode}');
    debugPrint('verifyOtpEmail → body: ${res.bodyString}');
    if (res.statusCode != 200) {
      throw Exception(_errMsg(res, 'OTP verification failed'));
    }
    return Map<String, dynamic>.from(res.body as Map);
  }



  Future<void> createUser(Map<String, dynamic> body) async {
    // Remove nulls so we don't send keys the user didn't use
    body.removeWhere((k, v) => v == null);

    final res = await post(
      '/v1/user/create-user',
      body,
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint('createUser → status: ${res.statusCode}');
    debugPrint('createUser → body: ${res.bodyString}');

    // Success contract per your Postman screenshots: 201 + {"data":"..."}
    if (res.statusCode != 201) {
      throw Exception(_extractErrorMessage(res));
    }
    if (res.body is! Map || res.body['data'] == null) {
      throw Exception('Unexpected response from server.');
    }
  }

  // ---------- shared error parser ----------
  String _extractErrorMessage(Response res) {
    try {
      final b = res.body;
      if (b is Map) {
        if (b['message'] is String && (b['message'] as String).isNotEmpty) {
          return b['message'];
        }
        // Sometimes validation errors are nested
        final details = b['errDetails'];
        if (details is Map && details['errors'] != null) {
          final errs = details['errors'];
          if (errs is List && errs.isNotEmpty) {
            final first = errs.first;
            if (first is Map && first['message'] is String) {
              return first['message'];
            }
          }
        }
      }
    } catch (_) {}
    return 'Request failed (${res.statusCode}).';
  }



  Future<Map<String, dynamic>> loginWithPhone({
    required String ext,
    required String phone,
    required String password,
  }) async {
    final res = await post('/v1/token/get-token',
        {'ext': ext, 'phone': phone, 'password': password},
        headers: {'Content-Type': 'application/json'});

    debugPrint('loginWithPhone → ${res.statusCode} ${res.bodyString}');

    if (res.statusCode != 201 && res.statusCode != 200) {
      final msg = (res.body is Map && res.body['message'] != null)
          ? res.body['message'].toString()
          : 'Login failed (${res.statusCode})';
      throw Exception(msg);
    }
    final data = (res.body is Map) ? res.body['data'] : null;
    if (data is! Map) throw Exception('Malformed login response.');
    return Map<String, dynamic>.from(data);
  }

  /// If your email login uses a different endpoint, change the path below.
  /// Many backends expose `/v1/token/get-token-email` for email logins.
  Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final res = await post('/v1/token/get-token',
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});

    debugPrint('loginWithEmail → ${res.statusCode} ${res.bodyString}');

    if (res.statusCode != 201 && res.statusCode != 200) {
      final msg = (res.body is Map && res.body['message'] != null)
          ? res.body['message'].toString()
          : 'Login failed (${res.statusCode})';
      throw Exception(msg);
    }
    final data = (res.body is Map) ? res.body['data'] : null;
    if (data is! Map) throw Exception('Malformed login response.');
    return Map<String, dynamic>.from(data);
  }


  Future<void> requestRecoverOtpEmail({required String email}) async {
    final res = await post(
      '/v1/auth/forgot-otp-email',
      {'email': email},
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint('requestRecoverOtpEmail → ${res.statusCode}');
    debugPrint('requestRecoverOtpEmail → ${res.bodyString}');

    if (res.statusCode != 200) {
      throw Exception(_errMsg(res, 'Failed to send email OTP'));
    }
  }

  Future<void> requestRecoverOtpSms({
    required String ext,
    required String phone,
  }) async {
    final res = await post(
      '/v1/auth/forgot-otp-sms',
      {'ext': ext, 'phone': phone},
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint('requestRecoverOtpSms → ${res.statusCode}');
    debugPrint('requestRecoverOtpSms → ${res.bodyString}');

    if (res.statusCode != 200) {
      throw Exception(_errMsg(res, 'Failed to send SMS OTP'));
    }
  }



  // ---------- Reset password (email) ----------
  Future<void> resetPasswordEmail({
    required String email,
    required String password,
  }) async {
    final res = await post(
      '/v1/auth/reset-password-email',
      {'email': email, 'password': password},
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('resetPasswordEmail → ${res.statusCode} ${res.bodyString}');
    _ensureOk(res, 'Failed to reset password (email).');
  }

  // ---------- Reset password (phone) ----------
  Future<void> resetPasswordPhone({
    required String ext,
    required String phone,
    required String password,
  }) async {
    final res = await post(
      '/v1/auth/reset-password-phone',
      {'ext': ext, 'phone': phone, 'password': password},
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint('resetPasswordPhone → ${res.statusCode} ${res.bodyString}');
    _ensureOk(res, 'Failed to reset password (phone).');
  }


}
