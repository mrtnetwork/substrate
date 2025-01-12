import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/pages/fields/storage.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
import 'package:substrate/future/widgets/widgets/conditional.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/drop_down.dart';
import 'package:substrate/future/widgets/widgets/large_text.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/future/widgets/widgets/sliver/sliver.dart';
import 'package:substrate/future/widgets/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';
import 'package:substrate/future/widgets/widgets/unfocusable.dart';

enum _StoragePage { select, query }

class HomeStorageAccess extends StatefulWidget {
  const HomeStorageAccess({this.scrollController, super.key});
  final ScrollController? scrollController;

  @override
  State<HomeStorageAccess> createState() => _HomeStorageAccessState();
}

class _HomeStorageAccessState extends State<HomeStorageAccess>
    with SafeState<HomeStorageAccess>, AutomaticKeepAliveClientMixin {
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
      MetadataTypeInfo? loockup = i.inputLookupId == null
          ? null
          : controller.substrate.api.metadata
              .getLookup(i.inputLookupId!)
              .typeInfo(controller.substrate.api.registry, 0);
      loockup = loockup?.copyWith(name: i.viewName);
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
    progressKey.backToIdle();
  }

  bool get canPop => page == _StoragePage.select;

  void onBackButton() {
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
    super.build(context);
    return Scaffold(
      appBar: page == _StoragePage.select
          ? null
          : AppBar(
              title: Text(
                  "query_storages_n".tr.replaceOne(storages.length.toString())),
              leading: IconButton(
                  onPressed: onBackButton, icon: const Icon(Icons.arrow_back)),
            ),
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
      body: UnfocusableChild(
        child: PageProgress(
          key: progressKey,
          backToIdle: APPConst.oneSecoundDuration,
          initialStatus: StreamWidgetStatus.progress,
          initialWidget:
              ProgressWithTextView(text: 'retrieving_storages_please_wait'.tr),
          child: (context) => APPAnimatedSwitcher(enable: page, widgets: {
            _StoragePage.select: (context) {
              return CustomScrollView(
                slivers: [
                  SliverMainAxisGroup(slivers: [
                    SliverPinnedHeaderSurface(
                        elevation: APPConst.elevation,
                        child: AppDropDownBottom(
                            items: items,
                            onChanged: onChangePallet,
                            value: pallet)),
                    SliverPadding(
                      padding: WidgetConstant.paddingHorizontal20,
                      sliver:
                          APPSliverAnimatedSwitcher(enable: pallet, widgets: {
                        pallet: (context) => PalletStoragesView(
                            pallet: pallet,
                            onTap: onTapStorage,
                            storages: storages)
                      }),
                    ),
                    WidgetConstant.sliverPaddingVertial40
                  ]),
                ],
              );
            },
            _StoragePage.query: (context) => StorageFieldsWidget(
                fields: fields,
                pallet: pallet,
                scrollController: widget.scrollController)
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

typedef ONTAPSTORAGE = void Function(StorageInfo);

class PalletStoragesView extends StatelessWidget {
  const PalletStoragesView(
      {super.key,
      required this.pallet,
      required this.onTap,
      required this.storages});
  final PalletInfo pallet;
  final ONTAPSTORAGE onTap;
  final List<StorageInfo> storages;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
        itemBuilder: (context, index) {
          final storage = pallet.storage![index];
          return AppCheckListTile(
              title: Text(storage.name),
              maxLine: 10,
              onChanged: (v) {
                onTap(storage);
              },
              value: storages.contains(storage),
              contentPadding: EdgeInsets.zero,
              subtitle:
                  LargeTextView(storage.docs, textAligen: TextAlign.start));
        },
        itemCount: pallet.storage!.length);
  }
}
