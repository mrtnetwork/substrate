import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/container.dart';
import 'package:substrate/future/widgets/widgets/copyable_text.dart';
import 'package:substrate/future/widgets/widgets/drop_down.dart';
import 'package:substrate/future/widgets/widgets/large_text.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/future/widgets/widgets/selectable_text.dart';
import 'package:substrate/future/widgets/widgets/sliver/sliver.dart';
import 'package:substrate/future/widgets/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class HomeConstantsAccess extends StatefulWidget {
  const HomeConstantsAccess({this.scrollController, super.key});
  final ScrollController? scrollController;

  @override
  State<HomeConstantsAccess> createState() => _HomeConstantsAccessState();
}

class _HomeConstantsAccessState extends State<HomeConstantsAccess>
    with SafeState<HomeConstantsAccess>, AutomaticKeepAliveClientMixin {
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
    super.build(context);
    return PageProgress(
      key: progressKey,
      backToIdle: APPConst.oneSecoundDuration,
      initialStatus: StreamWidgetStatus.progress,
      initialWidget:
          ProgressWithTextView(text: 'retrieving_constants_please_wait'.tr),
      child: (context) {
        return CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverMainAxisGroup(slivers: [
              SliverPinnedHeaderSurface(
                  elevation: APPConst.elevation,
                  child: AppDropDownBottom(
                      items: items, onChanged: onChangePallet, value: pallet)),
              SliverPadding(
                padding: WidgetConstant.paddingHorizontal20,
                sliver: APPSliverAnimatedSwitcher(enable: pallet, widgets: {
                  pallet: (context) => PalletConstantsView(pallet: pallet)
                }),
              )
            ]),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PalletConstantsView extends StatelessWidget {
  const PalletConstantsView({super.key, required this.pallet});
  final PalletInfo pallet;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final call = pallet.contants![index];
        return AppListTile(
            title: Text(call.name),
            maxLine: 10,
            trailing: IconButton(
                onPressed: () {
                  context.openSliverDialog((context) {
                    return ContainerWithBorder(
                      child: CopyableTextWidget(
                        text: call.value?.toString() ?? '',
                        color: context.onPrimaryContainer,
                        maxLines: null,
                        widget: APPSelectableText(
                          call.value?.toString() ?? '',
                          style: context.onPrimaryTextTheme.titleMedium,
                        ),
                      ),
                    );
                  }, call.name);
                },
                icon: const Icon(Icons.remove_red_eye)),
            contentPadding: EdgeInsets.zero,
            subtitle: LargeTextView(call.docs, textAligen: TextAlign.start));
      },
      itemCount: pallet.contants!.length,
    );
  }
}
