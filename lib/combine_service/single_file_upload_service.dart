import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadException implements Exception {
  final String message;
  UploadException(this.message);
}

class SingleFileUploadService {
  SingleFileUploadService({String? baseUrl, this.authToken})
      : _baseUrl = (baseUrl ?? dotenv.env['API_BASE_URL'] ?? '').trim() {
    if (_baseUrl.isEmpty) {
      throw UploadException('API_BASE_URL is missing from .env');
    }
  }

  final String _baseUrl;
  final String? authToken;

  Future<String> upload(File file) async {
    final uri = Uri.parse('$_baseUrl/v1/user/profile/upload-file-and-photo');

    final req = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('asset', file.path));

    if (authToken != null && authToken!.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $authToken';
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    // ✅ Debug: print status and body
    print('Upload status: ${res.statusCode}');
    print('Upload response body: ${res.body}');

    if (res.statusCode == 200) {
      // response like: { "data":"https://storage.googleapis.com/..." }
      final url = RegExp(r'"data"\s*:\s*"([^"]+)"')
          .firstMatch(res.body)
          ?.group(1);
      if (url == null || url.isEmpty) {
        throw UploadException('Upload succeeded but URL missing');
      }
      return url;
    } else if (res.statusCode == 422) {
      throw UploadException('File too large or invalid type');
    } else if (res.statusCode == 400) {
      throw UploadException('Bad request (check "asset" field & file count)');
    } else {
      throw UploadException('Upload failed (${res.statusCode})');
    }
  }

}
