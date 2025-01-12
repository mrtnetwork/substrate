import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/pages/home/pages/constants.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/constraint.dart';
import 'package:substrate/future/widgets/widgets/drop_down.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/future/widgets/widgets/sliver/sliver.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class QuickConstantsAccess extends StatefulWidget {
  const QuickConstantsAccess({this.scrollController, super.key});
  final ScrollController? scrollController;

  @override
  State<QuickConstantsAccess> createState() => _QuickConstantsAccessState();
}

class _QuickConstantsAccessState extends State<QuickConstantsAccess>
    with SafeState<QuickConstantsAccess> {
  late final List<PalletInfo> contantsPallets;
  final GlobalKey<PageProgressState> progressKey = GlobalKey();

  Map<PalletInfo, Text> items = {};

  late PalletInfo pallet;
  void onChangePallet(PalletInfo? pallet) {
    this.pallet = pallet ?? this.pallet;
    updateState();
  }

  Future<void> init() async {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    contantsPallets = controller.substrate.constantPallets();
    items = {for (final i in contantsPallets) i: Text(i.name)};
    pallet = contantsPallets.first;
    progressKey.backToIdle();
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    MethodUtils.after(() => init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("constants".tr)),
      body: PageProgress(
        key: progressKey,
        backToIdle: APPConst.oneSecoundDuration,
        initialStatus: StreamWidgetStatus.progress,
        initialWidget:
            ProgressWithTextView(text: 'retrieving_constants_please_wait'.tr),
        child: (context) {
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
                      sliver:
                          APPSliverAnimatedSwitcher(enable: pallet, widgets: {
                        pallet: (context) => PalletConstantsView(pallet: pallet)
                      }),
                    )
                  ])),
            ],
          );
        },
      ),
    );
  }
}
