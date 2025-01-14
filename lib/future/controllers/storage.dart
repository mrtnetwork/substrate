import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/forms/models/metadata.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class StorageFieldsStateController extends StateController {
  StorageFieldsStateController(
      {required this.fields, required this.api, required this.pallet});
  final SubstrateApi api;
  final List<StorageLookupField> fields;
  late final List<MetadataFormValidator?> forms;
  final PalletInfo pallet;
  // final form =
  //     loockup == null ? null : MetadataFormValidator.fromType(loockup);
  final GlobalKey<FormState> formState =
      GlobalKey(debugLabel: "FieldsStateController_formState");
  final GlobalKey<PageProgressState> progressKey =
      GlobalKey(debugLabel: "FieldsStateController_progressKey");

  bool _showResult = false;
  bool get showResult => _showResult;

  List<String> _results = [];
  List<String> get results => _results;

  Future<void> callStorage() async {
    if (!(formState.currentState?.validate() ?? false)) return;
    progressKey.progressText("retrieving_data_please_wait".tr);
    final r = await MethodUtils.call(() async {
      return api.api.queryStorageAt(
          requestes: List.generate(fields.length, (i) {
            final field = fields[i];
            final input = forms[i]?.getResult();
            return QueryStorageRequest(
                palletNameOrIndex: pallet.name,
                methodName: field.storage.name,
                identifier: i,
                input: input);
          }),
          rpc: api.client.provider,
          fromTemplate: false);
    });
    if (r.hasError) {
      progressKey.errorText(r.error!.tr,
          backToIdle: false, showBackButton: true);
    } else {
      final results = List.generate(fields.length, (i) {
        final result = r.result.getResult(i);
        if (result is Map) {
          return StringUtils.fromJson(result,
              indent: '  ', toStringEncodable: true);
        } else {
          return result.toString();
        }
      });
      _results = results;
      _showResult = true;
      progressKey.success();
    }
  }

  void cleanUpState() {
    _results.clear();
    _showResult = false;
    notify();
  }

  @override
  void init() {
    super.init();
    forms = fields
        .map((e) =>
            e.form == null ? null : MetadataFormValidator.fromType(e.form!))
        .toImutableList;
  }

  @override
  void close() {
    super.close();
    for (final i in forms) {
      i?.dispose();
    }
  }
}
