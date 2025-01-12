class SubstrateAppException implements Exception {
  const SubstrateAppException.error(this.message);

  final String message;
  const SubstrateAppException(this.message);
  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(other) {
    if (other is! SubstrateAppException) return false;
    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class WalletExceptionConst {
  static const SubstrateAppException castingFailed =
      SubstrateAppException("casting_failed");
}
