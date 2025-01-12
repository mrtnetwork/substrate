import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/pages/fields/storage.dart';
import 'package:substrate/future/pages/home/pages/storage.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
import 'package:substrate/future/widgets/widgets/conditional.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/constraint.dart';
import 'package:substrate/future/widgets/widgets/drop_down.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/future/widgets/widgets/sliver/sliver.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

enum _StoragePage { select, query }

class QuickStorageAccess extends StatefulWidget {
  const QuickStorageAccess({this.scrollController, this.storage, super.key});
  final ScrollController? scrollController;
  final StorageInfo? storage;

  @override
  State<QuickStorageAccess> createState() => _QuickStorageAccessState();
}

class _QuickStorageAccessState extends State<QuickStorageAccess>
    with SafeState<QuickStorageAccess> {
  late final List<PalletInfo> contantsPallets;
  final GlobalKey<PageProgressState> progressKey = GlobalKey();
  final List<StorageInfo> storages = [];
  _StoragePage page = _StoragePage.select;
  List<StorageLookupField> fields = [];

  void queryStorages() {
    if (storages.isEmpty) return;
    final List<StorageLookupField> fields = [];
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    for (final i in storages) {
      final loockup = i.inputLookupId == null
          ? null
          : controller.substrate.api.metadata
              .getLookup(i.inputLookupId!)
              .typeInfo(controller.substrate.api.registry, 0);

      final field = StorageLookupField(form: loockup, storage: i);
      fields.add(field);
    }
    this.fields = fields;
    page = _StoragePage.query;
    updateState();
  }

  Map<PalletInfo, Text> items = {};

  late PalletInfo pallet;
  void onChangePallet(PalletInfo? pallet) {
    this.pallet = pallet ?? this.pallet;
    updateState();
  }

  void onTapStorage(StorageInfo storage) {
    final r = storages.remove(storage);
    if (!r) {
      storages.add(storage);
    }
    updateState();
  }

  Future<void> init() async {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    contantsPallets = controller.substrate.storagePallets();
    items = {for (final i in contantsPallets) i: Text(i.name)};
    pallet = contantsPallets.first;
    if (widget.storage != null) {
      storages.add(widget.storage!);
      queryStorages();
    }
    progressKey.backToIdle();
  }

  bool get canPop => page == _StoragePage.select;

  void onBackButton(bool _, dynamic __) {
    if (canPop) return;
    page = _StoragePage.select;
    updateState();
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    MethodUtils.after(() => init(), duration: APPConst.animationDuraion);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onBackButton,
      child: Scaffold(
        appBar: AppBar(title: Text("storages".tr)),
        floatingActionButton: ConditionalWidget(
          enable: page == _StoragePage.select,
          onActive: (context) => ConditionalWidget(
              onDeactive: (context) => WidgetConstant.sizedBox,
              onActive: (context) => FloatingActionButton.extended(
                    onPressed: () {
                      queryStorages();
                    },
                    label: Text("query_storages_n"
                        .tr
                        .replaceOne(storages.length.toString())),
                  ),
              enable: storages.isNotEmpty),
        ),
        body: PageProgress(
          key: progressKey,
          backToIdle: APPConst.oneSecoundDuration,
          initialStatus: StreamWidgetStatus.progress,
          initialWidget:
              ProgressWithTextView(text: 'retrieving_storages_please_wait'.tr),
          child: (context) => APPAnimatedSwitcher(enable: page, widgets: {
            _StoragePage.select: (context) {
              return CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverConstraintsBoxView(
                      padding: WidgetConstant.paddingHorizontal10,
                      sliver: SliverMainAxisGroup(slivers: [
                        SliverPinnedHeaderSurface(
                            elevation: APPConst.elevation,
                            child: AppDropDownBottom(
                                items: items,
                                onChanged: onChangePallet,
                                value: pallet)),
                        SliverPadding(
                          padding: WidgetConstant.paddingHorizontal20,
                          sliver: APPSliverAnimatedSwitcher(
                              enable: pallet,
                              widgets: {
                                pallet: (context) => PalletStoragesView(
                                    pallet: pallet,
                                    onTap: onTapStorage,
                                    storages: storages)
                              }),
                        )
                      ])),
                ],
              );
            },
            _StoragePage.query: (context) => StorageFieldsWidget(
                  fields: fields,
                  pallet: pallet,
                  scrollController: widget.scrollController,
                )
          }),
        ),
      ),
    );
  }
}
