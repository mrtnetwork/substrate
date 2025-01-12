import 'package:blockchain_utils/helper/helper.dart';
import 'package:substrate/app/error/exception/wallet_ex.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

abstract class LookupField {
  const LookupField();
  T cast<T extends LookupField>() {
    if (this is! T) {
      throw WalletExceptionConst.castingFailed;
    }
    return this as T;
  }
}

class CallLookupField extends LookupField {
  final MetadataTypeInfo type;
  final int lockupId;
  final Si1Variant variant;
  final CallMethodInfo method;
  const CallLookupField(
      {required this.type,
      required this.lockupId,
      required this.variant,
      required this.method});
}

class StorageLookupField extends LookupField {
  final MetadataTypeInfo? form;
  final StorageInfo storage;
  const StorageLookupField({required this.form, required this.storage});
}

class RuntimeMethodLookupField extends LookupField {
  final List<MetadataTypeInfo> validators;
  final RuntimeApiMethodInfo method;
  final String apiName;
  RuntimeMethodLookupField(
      {required List<MetadataTypeInfo> validators,
      required this.method,
      required this.apiName})
      : validators = validators.immutable;
}

class ExtrinsicLookupField extends LookupField {
  final MetadataTypeInfo call;
  final MetadataTypeInfo? address;
  final MetadataTypeInfo? signature;
  final List<MetadataTypeInfo> extrinsicValidators;
  final List<MetadataTypeInfo> extrinsicPayloadValidators;
  final TransactionExtrinsicInfo extrinsicInfo;
  ExtrinsicLookupField({
    required List<MetadataTypeInfo> extrinsicValidators,
    required List<MetadataTypeInfo> extrinsicPayloadValidators,
    required this.call,
    required this.extrinsicInfo,
    required this.address,
    required this.signature,
  })  : extrinsicValidators = extrinsicValidators.immutable,
        extrinsicPayloadValidators = extrinsicPayloadValidators.immutable;
}
