import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/pages/fields/runtime_api.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/constraint.dart';
import 'package:substrate/future/widgets/widgets/drop_down.dart';
import 'package:substrate/future/widgets/widgets/large_text.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/future/widgets/widgets/sliver/sliver.dart';
import 'package:substrate/future/widgets/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

enum _APIPage { select, api }

class QuickRuntimeAPIAccess extends StatefulWidget {
  const QuickRuntimeAPIAccess({this.scrollController, super.key});
  final ScrollController? scrollController;

  @override
  State<QuickRuntimeAPIAccess> createState() => _QuickRuntimeAPIAccessState();
}

class _QuickRuntimeAPIAccessState extends State<QuickRuntimeAPIAccess>
    with SafeState<QuickRuntimeAPIAccess> {
  late final List<RuntimeApiInfo> apis;
  final GlobalKey<PageProgressState> progressKey = GlobalKey();
  _APIPage page = _APIPage.select;
  RuntimeMethodLookupField? field;

  void onTapMethod(RuntimeApiMethodInfo method) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    List<MetadataTypeInfo> fields = [];
    for (final i in method.inputs ?? <RuntimeApiInputInfo>[]) {
      MetadataTypeInfo loockup = controller.substrate.api.metadata
          .getLookup(i.lockupId)
          .typeInfo(controller.substrate.api.registry, 0);
      loockup = loockup.copyWith(name: loockup.name ?? i.name);
      fields.add(loockup);
    }
    field = RuntimeMethodLookupField(
        method: method, validators: fields, apiName: api.name);
    page = _APIPage.api;
    updateState();
  }

  Map<RuntimeApiInfo, Text> items = {};

  late RuntimeApiInfo api;
  void onChangePallet(RuntimeApiInfo? api) {
    this.api = api ?? this.api;
    updateState();
  }

  Future<void> init() async {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    apis = controller.substrate.metadataInfo.apis!;
    items = {for (final i in apis) i: Text(i.name)};
    api = apis.first;
    progressKey.backToIdle();
  }

  bool get canPop => page == _APIPage.select;

  void onBackButton(bool _, dynamic __) {
    if (canPop) return;
    page = _APIPage.select;
    field = null;
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
        appBar: AppBar(title: Text("runtime_apis".tr)),
        body: PageProgress(
          key: progressKey,
          backToIdle: APPConst.oneSecoundDuration,
          initialStatus: StreamWidgetStatus.progress,
          initialWidget:
              ProgressWithTextView(text: 'retrieving_storages_please_wait'.tr),
          child: (context) => APPAnimatedSwitcher(enable: page, widgets: {
            _APIPage.select: (context) {
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
                                value: api)),
                        SliverPadding(
                          padding: WidgetConstant.paddingHorizontal20,
                          sliver:
                              APPSliverAnimatedSwitcher(enable: api, widgets: {
                            api: (context) => SliverList.builder(
                                  itemBuilder: (context, index) {
                                    final method = api.methods![index];
                                    return AppListTile(
                                        title: Text(method.viewName),
                                        maxLine: 10,
                                        trailing: IconButton(
                                            onPressed: () {
                                              onTapMethod(method);
                                            },
                                            icon: const Icon(Icons.build)),
                                        contentPadding: EdgeInsets.zero,
                                        subtitle: LargeTextView(method.docs,
                                            textAligen: TextAlign.start));
                                  },
                                  itemCount: api.methods!.length,
                                )
                          }),
                        )
                      ])),
                ],
              );
            },
            _APIPage.api: (context) => RuntimeAPIsFieldsWidget(
                field: field!, scrollController: widget.scrollController)
          }),
        ),
      ),
    );
  }
}
