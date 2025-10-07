import 'dart:convert';
import 'dart:io';
import 'package:ambufast_driver/combine_service/upload_exception_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../network/token_http_client.dart';
import '../combine_service/token_refresh_service.dart';
import '../storage/token_storage.dart';


class MultiFileUploadService {
  MultiFileUploadService({
    String? baseUrl,
    http.Client? client,
  })  : _baseUrl = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? '').trim(),
        _client = client ?? TokenHttpClient() {
    if (_baseUrl.isEmpty) {
      throw const UploadException('API_BASE_URL is missing from .env');
    }
  }

  final String _baseUrl;
  final http.Client _client;

  static const _maxFiles = 10;
  static const _maxBytes = 10 * 1024 * 1024; // 10MB/file
  static const _allowedExt = {'jpg', 'jpeg', 'png', 'webp'};

  /// Upload many images with field name `assets`.
  /// Returns list of public URLs.
  Future<List<String>> uploadMany(List<File> files) async {
    if (files.isEmpty) return const [];
    if (files.length > _maxFiles) {
      throw UploadException('Too many files. Max is $_maxFiles.');
    }
    for (final f in files) {
      await _validate(f);
    }

    var res = await _sendOnce(files);

    // 401 → refresh + rebuild + retry once
    if (res.statusCode == 401) {
      final ok = await TokenAuthService.refreshAccessToken();
      if (!ok) {
        await TokenStorage.clearTokens();
        throw const UploadException('Unauthorized (token refresh failed)', statusCode: 401);
      }
      res = await _sendOnce(files);
    }

    if (kDebugMode) {
      print('⬅️ [MultiUpload] ${res.statusCode}: ${res.body}');
    }

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'];
      if (data is List) {
        // BE returns list of URLs
        return data.map((e) => e.toString()).toList();
      }
      throw  UploadException('Invalid response format.', statusCode: 200);
    }
    if (res.statusCode == 400) {
      throw  UploadException('Bad request (field name should be "assets"; check file count)', statusCode: 400);
    }
    if (res.statusCode == 422) {
      throw  UploadException('Validation failed (type/size)', statusCode: 422);
    }

    throw UploadException('Upload failed (${res.statusCode})', statusCode: res.statusCode);
  }

  Future<http.Response> _sendOnce(List<File> files) async {
    final uri = Uri.parse('$_baseUrl/v1/user/profile/upload-files-and-photos');
    final mp = http.MultipartRequest('POST', uri)..headers['Accept'] = 'application/json';

    for (final f in files) {
      final mime = lookupMimeType(f.path) ?? 'application/octet-stream';
      mp.files.add(await http.MultipartFile.fromPath(
        'assets', // BE expects 'assets' (array)
        f.path,
        contentType: MediaType.parse(mime),
      ));
    }

    final streamed = await _client.send(mp);
    return http.Response.fromStream(streamed);
  }

  Future<void> _validate(File f) async {
    final path = f.path;
    final ext = path.split('.').last.toLowerCase();
    if (!_allowedExt.contains(ext)) {
      throw UploadException('Only ${_allowedExt.join(", ").toUpperCase()} allowed. Offending: $path');
    }
    final length = await f.length();
    if (length > _maxBytes) {
      throw UploadException('File too large (> ${_maxBytes ~/ (1024 * 1024)}MB): $path');
    }
  }
}
