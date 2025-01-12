import 'package:blockchain_utils/utils/utils.dart';
import 'package:blockchain_utils/layout/constant/constant.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

/// Returns the metadata at a given version
/// https://polkadot.js.org/docs/substrate/runtime/#metadata
class SubstrateGetApiAt extends SubstrateRequest<String, MetadataApi?> {
  const SubstrateGetApiAt(this.version);
  final int version;

  @override
  String get rpcMethod => SubstrateRequestMethods.stateCall.value;

  @override
  List<dynamic> toJson() {
    final val = BytesUtils.toHexString(LayoutConst.u32().serialize(version),
        prefix: "0x");
    return ["Metadata_metadata_at_version", val, null];
  }

  @override
  MetadataApi? onResonse(String result) {
    try {
      final toBytes = BytesUtils.fromHexString(result);
      final decode =
          LayoutConst.optional(LayoutConst.bytes()).deserialize(toBytes).value;
      if (decode == null) return null;
      return VersionedMetadata.fromBytes(decode).toApi();
    } catch (e) {
      return null;
    }
  }
}

class SubstrateGetStateApi extends SubstrateRequest<String, MetadataApi?> {
  const SubstrateGetStateApi({this.atBlockHash});

  final String? atBlockHash;

  @override
  String get rpcMethod => SubstrateRequestMethods.getMetadata.value;

  @override
  List<dynamic> toJson() {
    return [atBlockHash];
  }

  @override
  MetadataApi? onResonse(String result) {
    try {
      final toBytes = BytesUtils.fromHexString(result);
      final versioned = VersionedMetadata.fromBytes(toBytes);
      return versioned.toApi();
    } catch (e) {
      return null;
    }
  }
}
