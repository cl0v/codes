class DictionaryException implements Exception {
  final int? statusCode;
  final String? message;

  DictionaryException({
    this.statusCode,
    this.message,
  });
}
