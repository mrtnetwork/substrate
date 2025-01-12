import 'package:substrate/app/tools/url_luncher.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/pages/home/pages/add_new_chain.dart';
import 'package:substrate/future/pages/home/pages/call.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/theme/theme.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/future/widgets/widgets/color_selector.dart';
import 'package:flutter/material.dart';
import 'pages/constants.dart';
import 'pages/extersinc.dart';
import 'pages/network.dart';
import 'pages/runtime_api.dart';
import 'pages/storage.dart';

class SubstrateHome extends StatelessWidget {
  const SubstrateHome({super.key});
  PreferredSizeWidget _buildAppBar(APPStateController controller) {
    if (controller.inited) {
      return AppBar(
        bottom: TabBar(isScrollable: true, tabs: [
          Tab(text: "network".tr),
          Tab(text: "storages".tr),
          Tab(text: "constants".tr),
          Tab(text: "calls".tr),
          if (controller.substrate.supportRuntimeApi)
            Tab(text: "runtime_apis".tr),
          Tab(text: "extrinsic".tr)
        ]),
        title: ConditionalWidget(
          enable: controller.inited,
          onActive: (context) {
            return Text(controller.substrate.name);
          },
        ),
      );
    }
    return AppBar(
      title: Text("substrate".tr),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MrtViewBuilder(
      controller: () => context.watch<APPStateController>(APPConst.stateMain),
      repositoryId: APPConst.stateMain,
      builder: (controller) {
        return DefaultTabController(
          length: controller.inited && controller.substrate.supportRuntimeApi
              ? 6
              : 5,
          child: Scaffold(
            key: controller.scaffoldKey,
            drawer: DrawerWidget(controller),
            appBar: _buildAppBar(controller),
            body: PageProgress(
              backToIdle: APPConst.oneSecoundDuration,
              key: controller.pageProgress,
              initialStatus: StreamWidgetStatus.progress,
              child: (context) =>
                  APPAnimatedSwitcher(enable: controller.page, widgets: {
                HomePageMode.network: (context) => _NetworkPage(controller),
                HomePageMode.init: (context) =>
                    Scaffold(drawer: DrawerWidget(controller))
              }),
            ),
          ),
        );
        // return
      },
    );
  }
}

class _NetworkPage extends StatelessWidget {
  const _NetworkPage(this.controller);
  final APPStateController controller;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [],
        body: Builder(
          builder: (context) {
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false, physics: const ClampingScrollPhysics()),
              child: TabBarView(
                  physics: WidgetConstant.noScrollPhysics,
                  children: [
                    const HomeNetworkAccess(),
                    const HomeStorageAccess(),
                    const HomeConstantsAccess(),
                    const HomeCallAccess(),
                    if (controller.substrate.supportRuntimeApi)
                      const HomeRuntimeAPIAccess(),
                    const HomeExtrinsicAccess(),
                  ]),
            );
          },
        ));
  }
}

class DrawerWidget extends StatelessWidget {
  final APPStateController controller;
  const DrawerWidget(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          decoration: BoxDecoration(color: context.colors.secondary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('substrate'.tr,
                        style: TextStyle(
                            color: context.colors.onSecondary, fontSize: 24)),
                  ),
                  IconButton(
                      onPressed: () async {
                        await WebLauncher.launch(APPConst.repositoryPage);
                      },
                      icon: Icon(Icons.open_in_new,
                          color: context.colors.onSecondary)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        context.toPage(const AddNewChainView());
                      },
                      icon: Icon(Icons.add_box,
                          color: context.colors.onSecondary)),
                  BrightnessToggleIcon(
                      onToggleBrightness: () {
                        controller.toggleBrightness();
                      },
                      color: context.colors.onSecondary,
                      brightness: ThemeController.appTheme.brightness),
                  ColorSelectorIconView(
                    color: context.colors.onSecondary,
                    onSelectColor: (color) {
                      controller.changeColor(color);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        ...List.generate(controller.chains.length, (index) {
          {
            final chain = controller.chains.elementAt(index);
            final select = chain == controller.currentNetwork;
            return Theme(
              data: context.theme
                  .copyWith(dividerColor: context.colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: chain == controller.currentNetwork,
                title: Text(chain.name, style: context.textTheme.titleMedium),
                childrenPadding: WidgetConstant.paddingHorizontal10,
                trailing: select ? const Icon(Icons.check_circle) : null,
                children: [
                  AppListTile(
                    title: Text("add_new_service_provider".tr),
                    trailing: const Icon(Icons.add_box),
                    onTap: () {
                      context.toPage(AddNewChainView(updateChan: chain));
                    },
                  ),
                  ...List.generate(chain.rpcEndpoints.length, (i) {
                    final rpc = chain.rpcEndpoints.elementAt(i);
                    return AppRadioListTile(
                      maxLine: 1,
                      groupValue: controller.currentEndpoint,
                      value: rpc,
                      title: Text(rpc.name,
                          style: context.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: Text(rpc.url,
                          style: context.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      onChanged: (e) {
                        controller.switchChain(network: chain, endpoint: rpc);
                      },
                    );
                  }),
                ],
              ),
            );
          }
        }),
      ]),
    );
  }
}
