class TextRecognitionException implements Exception {
  final String message;
  const TextRecognitionException({required this.message});

  @override
  String toString() => 'TextRecognitionException: $message';
}

class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});

  @override
  String toString() => 'ServerException: $message';
}
