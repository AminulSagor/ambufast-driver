import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadException implements Exception {
  final String message;
  final int? statusCode;
  UploadException(this.message, {this.statusCode});
  @override
  String toString() => 'UploadException($statusCode): $message';
}

class MultiFileUploadService {
  MultiFileUploadService({String? baseUrl, this.authToken})
      : _baseUrl = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? '').trim() {
    if (_baseUrl.isEmpty) {
      throw UploadException('API_BASE_URL is missing from .env');
    }
  }

  final String _baseUrl;
  final String? authToken;

  static const _maxFiles = 10;
  static const _maxBytes = 10 * 1024 * 1024; // 10 MB per file
  static const _allowedExt = {'jpg', 'jpeg', 'png', 'webp'};

  /// Upload many images with field name `assets`.
  /// Returns the list of public URLs from the API.
  Future<List<String>> uploadMany(List<File> files) async {
    if (files.isEmpty) return const [];
    if (files.length > _maxFiles) {
      throw UploadException('Too many files. Max is $_maxFiles.');
    }

    final uri = Uri.parse('$_baseUrl/v1/user/profile/upload-files-and-photos');
    final req = http.MultipartRequest('POST', uri);

    if (authToken != null && authToken!.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $authToken';
    }

    for (final f in files) {
      final path = f.path;
      final ext = path.split('.').last.toLowerCase();
      if (!_allowedExt.contains(ext)) {
        throw UploadException('Only JPG, PNG or WEBP allowed. Offending: $path');
      }

      final length = await f.length();
      if (length > _maxBytes) {
        throw UploadException('File too large (>10MB): $path');
      }

      final mime = lookupMimeType(path) ?? 'application/octet-stream';
      req.files.add(
        await http.MultipartFile.fromPath(
          'assets', // matches Postman screenshots
          path,
          contentType: MediaType.parse(mime),
        ),
      );
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'];
      if (data is List) {
        return data.cast<String>();
      }
      throw UploadException('Invalid response format.', statusCode: res.statusCode);
    } else if (res.statusCode == 400) {
      throw UploadException('Bad request (check "assets" field & file count)',
          statusCode: res.statusCode);
    } else if (res.statusCode == 422) {
      throw UploadException('Validation failed (file too large or invalid)',
          statusCode: res.statusCode);
    } else {
      throw UploadException('Upload failed (${res.statusCode})',
          statusCode: res.statusCode);
    }
  }
}
