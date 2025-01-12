class CancelableExption implements Exception {
  const CancelableExption();

  String get message => "request_cancelled";
  @override
  String toString() {
    return message;
  }
}
