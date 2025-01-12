import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/metadata.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:substrate/substrate/models/extrinsic.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

enum ExtrinsicPage {
  createPayload("create_payload"),
  showPayload("review_and_sign_payload"),
  createExtrinsic("create_extrinsic"),
  showExtrinsic("review_and_broadcast_extrinsic");

  const ExtrinsicPage(this.name);

  final String name;
}

class ExtrinsicPayloadFieldsStateController extends StateController {
  ExtrinsicPayloadFieldsStateController({required this.appController});
  ExtrinsicPage _page = ExtrinsicPage.createPayload;
  ExtrinsicPage get page => _page;
  final APPStateController appController;
  SubstrateApi get api => appController.substrate;
  final GlobalKey<FormState> formState =
      GlobalKey(debugLabel: "RuntimeApiFieldsStateController_formState");
  final GlobalKey<PageProgressState> progressKey =
      GlobalKey(debugLabel: "RuntimeApiFieldsStateController_progressKey");
  late final TransactionExtrinsicInfo extrinsicLookupField;
  late final List<MetadataFormValidator>? extrinsicValidators;
  late final List<MetadataFormValidator> extrinsicPayloadValidators;
  ExtrinsicInfo? _extrinsicInfo;
  ExtrinsicInfo? get extrinsicInfo => _extrinsicInfo;
  ExtrinsicPayloadInfo? _payloadInfo;
  ExtrinsicPayloadInfo get payloadInfo => _payloadInfo!;
  Future<void> createPayload() async {
    if (!(formState.currentState?.validate() ?? false)) return;
    progressKey.progressText("creating_payload_please_wait".tr);
    final r = await MethodUtils.call(() async => _createPayload(),
        delay: APPConst.oneSecoundDuration);
    if (r.hasError) {
      progressKey.errorText(r.error!.tr,
          backToIdle: false, showBackButton: true);
    } else {
      _payloadInfo = r.result;
      _page = ExtrinsicPage.showPayload;
      notify();
      progressKey.backToIdle();
    }
  }

  (DynamicByteTracker, Map<String, dynamic>) _encodeCallPayload() {
    final byte = DynamicByteTracker();
    final Map<String, dynamic> extrinsicInfo = {};
    final form = extrinsicPayloadValidators[0] as MetadataFormValidatorVariant;
    final callInput = form.getResult();
    int? callLookupId = extrinsicLookupField.callType;
    if (callLookupId != null) {
      final encodeData = api.api
          .encodeLookup(id: callLookupId, value: callInput, fromTemplate: false)
          .asImmutableBytes;
      final decode = api.api.decodeLookup(callLookupId, encodeData);
      if (form.info.name != null) {
        extrinsicInfo[form.info.name!] = decode;
      }
      byte.add(encodeData);
    } else {
      callLookupId = form.variant!.fields[0].type;
      List<int> encodeData = api.api
          .encodeLookup(
              id: callLookupId,
              value: form.validator!.getResult(),
              fromTemplate: false)
          .asImmutableBytes;
      final decode = api.api.decodeLookup(callLookupId, encodeData);
      if (form.info.name != null) {
        extrinsicInfo[form.info.name!] = {form.variant!.name: decode};
      }
      encodeData = [form.variant!.index, ...encodeData];
      byte.add(encodeData);
    }
    return (byte, extrinsicInfo);
  }

  Future<ExtrinsicPayloadInfo> _createPayload() async {
    final callEncode = _encodeCallPayload();
    final byte = callEncode.$1;
    final List extrinsicInfo = [callEncode.$2];
    // final Map<String, dynamic> extrinsicInfo = callEncode.$2;
    final String callData = BytesUtils.toHexString(byte.toBytes());
    for (int i = 1; i < extrinsicPayloadValidators.length; i++) {
      final form = extrinsicPayloadValidators[i];
      final input = form.getResult();
      final lookupId = extrinsicLookupField.payloadExtrinsic[i - 1].id;
      final encodeData = api.api
          .encodeLookup(id: lookupId, value: input, fromTemplate: false)
          .asImmutableBytes;
      final decode = api.api.decodeLookup(lookupId, encodeData);
      if (form.info.name != null) {
        extrinsicInfo.add({form.info.name: decode});
      } else {
        extrinsicInfo.add(decode);
      }
      byte.add(encodeData);
    }
    final encodeBytes = byte.toBytes().asImmutableBytes;
    final encodeData = BytesUtils.toHexString(encodeBytes);
    String payload;
    if (encodeBytes.length >
        TransactionPalyloadConst.requiredHashDigestLength) {
      payload = BytesUtils.toHexString(QuickCrypto.blake2b256Hash(encodeBytes));
    } else {
      payload = encodeData;
    }
    return ExtrinsicPayloadInfo(
        payload: payload,
        serializedExtrinsic: encodeData,
        method: callData,
        payloadInfo: StringUtils.fromJson(extrinsicInfo,
            indent: ' ', toStringEncodable: true));
  }

  Future<void> createExtrinsic() async {
    if (!(formState.currentState?.validate() ?? false)) return;
    if (extrinsicValidators == null) {
      progressKey.errorText("address_signature_field_not_found_desc".tr,
          backToIdle: false, showBackButton: true);
      return;
    }
    progressKey.progressText("creating_extrinsic_please_wait".tr);
    final r = await MethodUtils.call(() async => _createExtrinsic(),
        delay: APPConst.oneSecoundDuration);
    if (r.hasError) {
      progressKey.errorText(r.error!.tr,
          backToIdle: false, showBackButton: true);
    } else {
      _extrinsicInfo = r.result;
      _page = ExtrinsicPage.showExtrinsic;
      notify();
      progressKey.backToIdle();
    }
  }

  Future<ExtrinsicInfo> _createExtrinsic() async {
    final byte = DynamicByteTracker();
    final Map<String, dynamic> extrinsicInfo = {};
    final lookupids = [
      extrinsicLookupField.addressType!,
      extrinsicLookupField.signatureType!,
      ...extrinsicLookupField.extrinsic.map((e) => e.id),
    ];
    for (int i = 0; i < extrinsicValidators!.length; i++) {
      final form = extrinsicValidators![i];
      final lookupId = lookupids[i];
      final input = form.getResult();

      final encodeData = api.api
          .encodeLookup(id: lookupId, value: input, fromTemplate: false)
          .asImmutableBytes;
      final decode = api.api.decodeLookup(lookupId, encodeData);
      if (form.info.name != null) {
        extrinsicInfo[form.info.name!] = decode;
      }
      byte.add(encodeData);
    }
    final encodeBytes = byte.toBytes().asImmutableBytes;
    final encodeData = BytesUtils.toHexString(encodeBytes);
    return ExtrinsicInfo(
        payload: payloadInfo,
        serializedExtrinsic: encodeData,
        version: extrinsicLookupField.version);
  }

  void updatePayload(ExtrinsicPayloadInfo? payload) {
    if (payload == null) return;
    if (payload.payload != _payloadInfo?.payload) return;
    _payloadInfo = payload;
    if (payload.hasSignature) {
      _page = ExtrinsicPage.createExtrinsic;
    }
    notify();
  }

  void onBackButton() {
    switch (_page) {
      case ExtrinsicPage.showExtrinsic:
        _extrinsicInfo = null;
        _page = ExtrinsicPage.createExtrinsic;
        break;
      case ExtrinsicPage.createExtrinsic:
        _payloadInfo = _payloadInfo?.setSignature(null);
        _page = ExtrinsicPage.showPayload;
        break;
      case ExtrinsicPage.showPayload:
        _payloadInfo = null;
        _page = ExtrinsicPage.createPayload;
        break;
      default:
    }
    notify();
    progressKey.backToIdle();
  }

  void _init() {
    final fields = api.buildExtrinsicFields();
    extrinsicLookupField = fields.extrinsicInfo;
    if (fields.address == null || fields.signature == null) {
      extrinsicValidators = null;
    } else {
      extrinsicValidators = [
        MetadataFormValidator.fromType(fields.address!),
        MetadataFormValidator.fromType(fields.signature!),
        ...fields.extrinsicValidators
            .map((e) => MetadataFormValidator.fromType(e))
      ];
    }

    extrinsicPayloadValidators = [
      MetadataFormValidator.fromType(fields.call),
      ...fields.extrinsicPayloadValidators
          .map((e) => MetadataFormValidator.fromType(e))
    ];
    progressKey.backToIdle();
  }

  Future<void> broadcastTx() async {
    progressKey.progressText("broadcast_extrinsic_please_wait".tr);
    final r = await MethodUtils.call(() async =>
        api.client.broadcastSerializedExtrinsic(extrinsicInfo!.serialize()));
    if (r.hasError) {
      progressKey.errorText(r.error!.tr,
          backToIdle: false, showBackButton: true);
    } else {
      progressKey.successText(r.result, backToIdle: false, copyable: true);
    }
  }

  @override
  void ready() {
    super.ready();
    MethodUtils.after(() async => _init(), duration: APPConst.animationDuraion);
  }
}
