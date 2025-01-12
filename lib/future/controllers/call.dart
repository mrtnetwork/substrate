import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/forms/models/metadata.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class CallFieldsStateController extends StateController {
  CallFieldsStateController(
      {required this.field, required this.api, required this.pallet});
  late final MetadataFormValidator form;
  final SubstrateApi api;
  final CallLookupField field;
  final PalletInfo pallet;
  final GlobalKey<FormState> formState =
      GlobalKey(debugLabel: "FieldsStateController_formState");
  final GlobalKey<PageProgressState> progressKey =
      GlobalKey(debugLabel: "FieldsStateController_progressKey");

  String? _encodedData;
  String? get encodedData => _encodedData;

  bool get showResult => _encodedData != null;
  Future<void> encodeCall() async {
    if (!(formState.currentState?.validate() ?? false)) return;

    progressKey.progressText("processing_data_please_wait".tr);
    final r = await MethodUtils.call(() async => _encodeCall(),
        delay: APPConst.oneSecoundDuration);
    if (r.hasError) {
      progressKey.errorText(r.error!.tr);
    } else {
      _encodedData = r.result;
      progressKey.backToIdle();
    }
  }

  String _encodeCall() {
    final r = {field.variant.name: form.getResult()};
    final encode =
        api.api.encodeLookup(id: field.lockupId, value: r, fromTemplate: false);
    return BytesUtils.toHexString(encode);
  }

  void clearState() {
    _encodedData = null;

    notify();
  }

  @override
  void init() {
    super.init();
    form = MetadataFormValidator.fromType(field.type);
  }

  @override
  void close() {
    super.close();
    form.dispose();
  }
}
