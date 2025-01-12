import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/pages/fields/call.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
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

class HomeCallAccess extends StatefulWidget {
  const HomeCallAccess({this.scrollController, super.key});
  final ScrollController? scrollController;

  @override
  State<HomeCallAccess> createState() => _HomeCallAccessState();
}

class _HomeCallAccessState extends State<HomeCallAccess>
    with SafeState<HomeCallAccess>, AutomaticKeepAliveClientMixin {
  late final List<PalletInfo> callPallets;
  final GlobalKey<PageProgressState> progressKey = GlobalKey();
  _StoragePage page = _StoragePage.select;
  CallLookupField? fields;

  void onTapMethod(CallMethodInfo method) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    final info = controller.substrate.getTypeInfo(method.variant);
    fields = CallLookupField(
        type: info,
        lockupId: pallet.calls!.id,
        variant: method.variant,
        method: method);
    page = _StoragePage.query;
    updateState();
  }

  Map<PalletInfo, Text> items = {};

  late PalletInfo pallet;
  void onChangePallet(PalletInfo? pallet) {
    this.pallet = pallet ?? this.pallet;
    updateState();
  }

  Future<void> init() async {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    callPallets = controller.substrate.callPallets();
    items = {for (final i in callPallets) i: Text(i.name)};
    pallet = callPallets.first;
    progressKey.backToIdle();
  }

  bool get canPop => page == _StoragePage.select;

  void onBackButton() {
    if (canPop) return;
    page = _StoragePage.select;
    updateState();
    fields = null;
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    MethodUtils.after(() => init(), duration: APPConst.animationDuraion);
  }

  PreferredSizeWidget? buildAppBar() {
    if (page == _StoragePage.select) return null;
    return AppBar(
      title: Text(fields!.method.name),
      leading: IconButton(
          onPressed: () {
            onBackButton();
          },
          icon: const Icon(Icons.arrow_back)),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: buildAppBar(),
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
                      sliver: APPSliverAnimatedSwitcher(
                          enable: pallet,
                          widgets: {
                            pallet: (context) => PalletStoragesView(
                                pallet: pallet, onTap: onTapMethod)
                          }),
                    )
                  ]),
                ],
              );
            },
            _StoragePage.query: (context) => CallFieldsWidget(
                  fields: fields!,
                  pallet: pallet,
                  scrollController: widget.scrollController,
                )
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

typedef ONTAPMETHOD = void Function(CallMethodInfo);

class PalletStoragesView extends StatelessWidget {
  const PalletStoragesView({
    super.key,
    required this.pallet,
    required this.onTap,
  });
  final PalletInfo pallet;
  final ONTAPMETHOD onTap;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final method = pallet.calls!.methods[index];
        return AppListTile(
            title: Text(method.name),
            maxLine: 10,
            trailing: IconButton(
                onPressed: () {
                  onTap(method);
                },
                icon: const Icon(Icons.build)),
            // onChanged: (v) {
            //   // onTap(storage);
            // },
            // value: storages.contains(storage),
            contentPadding: EdgeInsets.zero,
            subtitle: LargeTextView(method.docs, textAligen: TextAlign.start));
      },
      itemCount: pallet.calls!.methods.length,
    );
  }
}
