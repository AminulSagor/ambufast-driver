class UploadException implements Exception {
  final String message;
  final int? statusCode;
  const UploadException(this.message, {this.statusCode});

  @override
  String toString() => 'UploadException($statusCode): $message';
}
