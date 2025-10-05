// lib/network/token_http_client.dart
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../combine_service/token_refresh_service.dart';
import '../storage/token_storage.dart';

class TokenHttpClient extends http.BaseClient {
  final http.Client _inner;
  TokenHttpClient({http.Client? inner}) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Save body for retry if it's a http.Request (JSON, form, etc.)
    Uint8List? savedBody;
    if (request is http.Request) {
      savedBody = request.bodyBytes; // snapshot before sending
    }

    // Attach token
    final token = await TokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    http.StreamedResponse res = await _inner.send(request);

    // If unauthorized, try refresh for non-multipart requests
    if (res.statusCode == 401 && request is http.Request) {
      final refreshed = await TokenAuthService.refreshAccessToken();
      if (refreshed) {
        final newToken = await TokenStorage.getAccessToken();
        final retry = http.Request(request.method, request.url)
          ..headers.addAll(request.headers)
          ..bodyBytes = savedBody ?? Uint8List(0);

        retry.headers['Authorization'] = 'Bearer $newToken';
        return _inner.send(retry);
      } else {
        await TokenStorage.clearTokens();
        Get.offAllNamed('/login');
      }
    }

    return res;
  }
}
