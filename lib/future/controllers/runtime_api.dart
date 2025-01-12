import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/string/string.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/forms/models/metadata.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class RuntimeApiFieldsStateController extends StateController {
  RuntimeApiFieldsStateController({required this.field, required this.api});
  final SubstrateApi api;
  final RuntimeMethodLookupField field;
  late final List<MetadataFormValidator> forms;
  final GlobalKey<FormState> formState =
      GlobalKey(debugLabel: "RuntimeApiFieldsStateController_formState");
  final GlobalKey<PageProgressState> progressKey =
      GlobalKey(debugLabel: "RuntimeApiFieldsStateController_progressKey");

  bool _showResult = false;
  bool get showResult => _showResult;

  String? _result;
  String? get result => _result;

  Future<void> callStorage() async {
    if (!(formState.currentState?.validate() ?? false)) return;
    progressKey.progressText("retrieving_data_please_wait".tr);

    final r = await MethodUtils.call(() async {
      return api.api.runtimeCall(
          rpc: api.client.provider,
          fromTemplate: false,
          methodName: field.method.name,
          apiName: field.apiName,
          params: forms.map((e) => e.getResult()).toList());
    });
    if (r.hasError) {
      progressKey.errorText(r.error!.tr,
          backToIdle: false, showBackButton: true);
    } else {
      final result = r.result;
      if (result is Map) {
        _result =
            StringUtils.fromJson(result, indent: '', toStringEncodable: true);
      } else {
        _result = result.toString();
      }
      _showResult = true;
      progressKey.success();
    }
  }

  void cleanUpState() {
    _result = null;
    _showResult = false;
    notify();
  }

  @override
  void ready() {
    super.ready();
    forms = field.validators
        .map((e) => MetadataFormValidator.fromType(e))
        .toImutableList;
  }

  @override
  void close() {
    super.close();
    for (final i in forms) {
      i.dispose();
    }
  }
}
