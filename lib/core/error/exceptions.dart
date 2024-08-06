class SeverException implements Exception {
  final String message;
  SeverException(
    this.message,
  );
  @override
  String toString() {
    return message;
  }
}
