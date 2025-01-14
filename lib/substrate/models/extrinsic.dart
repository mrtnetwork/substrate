import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

import 'signature.dart';

class ExtrinsicPayloadInfo {
  final String payload;
  final String serializedExtrinsic;
  final String payloadInfo;
  final SubstrateSignature? signature;
  final String method;
  ExtrinsicPayloadInfo(
      {required this.payload,
      required this.serializedExtrinsic,
      required this.payloadInfo,
      required this.method,
      this.signature});

  ExtrinsicPayloadInfo setSignature(SubstrateSignature? signature) {
    // assert(this.signature == null);
    return ExtrinsicPayloadInfo(
        payload: payload,
        serializedExtrinsic: serializedExtrinsic,
        payloadInfo: payloadInfo,
        signature: signature,
        method: method);
  }

  bool get hasSignature => signature != null;
}

class ExtrinsicInfo {
  final int version;
  final ExtrinsicPayloadInfo payload;
  final String serializedExtrinsic;
  ExtrinsicInfo(
      {required this.payload,
      required this.serializedExtrinsic,
      required this.version});

  String serialize() {
    final extrinsicBytes = BytesUtils.fromHexString(serializedExtrinsic);
    final callData = BytesUtils.fromHexString(payload.method);
    final encode = [
      (version | SubstrateConstant.bitSigned),
      ...extrinsicBytes,
      ...callData
    ];
    return BytesUtils.toHexString(
        [...LayoutSerializationUtils.encodeLength(encode), ...encode],
        prefix: "0x");
  }
}
