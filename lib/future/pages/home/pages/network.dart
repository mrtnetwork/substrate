import 'dart:async';

import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class HomeNetworkAccess extends StatefulWidget {
  const HomeNetworkAccess({super.key});

  @override
  State<HomeNetworkAccess> createState() => _HomeNetworkAccessState();
}

class _HomeNetworkAccessState extends State<HomeNetworkAccess>
    with SafeState<HomeNetworkAccess> {
  late final APPStateController controller;
  RuntimeVersion get runtimeVersion => controller.substrate.runtimeVersion;
  SubstrateApi get substrate => controller.substrate;
  late Stream block;
  @override
  void onInitOnce() {
    super.onInitOnce();
    controller = context.watch<APPStateController>(APPConst.stateMain);
    controller.substrate;
    block = Stream.periodic(const Duration(seconds: kDebugMode ? 120 : 4))
        .transform(StreamTransformer<dynamic, String>.fromHandlers(
      handleData: (data, sink) async {
        final r = await controller.substrate.client.getFinalizBlock();
        sink.add(r.toHex());
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          WidgetConstant.sliverPaddingVertial20,
          SliverConstraintsBoxView(
              padding: WidgetConstant.paddingHorizontal10,
              sliver: SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(runtimeVersion.specName.camelCase,
                          style: context.textTheme.titleLarge),
                      Text(runtimeVersion.implName.camelCase,
                          style: context.textTheme.bodySmall),
                      WidgetConstant.height20,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NetworkPageKeyValue(
                              name: "spec_version".tr,
                              data: runtimeVersion.specVersion.toString(),
                              value: Text(runtimeVersion.specVersion.toString(),
                                  style: context.textTheme.titleMedium)),
                          _NetworkPageKeyValue(
                              name: "transaction_version".tr,
                              data:
                                  runtimeVersion.transactionVersion.toString(),
                              value: Text(
                                  runtimeVersion.transactionVersion.toString(),
                                  style: context.textTheme.titleMedium)),
                          ConditionalWidget(
                              onActive: (context) => _NetworkPageKeyValue(
                                  name: "state_version".tr,
                                  data: runtimeVersion.stateVersion.toString(),
                                  value: Text(
                                      runtimeVersion.stateVersion.toString(),
                                      style: context.textTheme.titleMedium)),
                              enable: runtimeVersion.stateVersion != null),
                          ConditionalWidget(
                              onActive: (context) => _NetworkPageKeyValue(
                                  name: "system_version".tr,
                                  data: runtimeVersion.systemVersion.toString(),
                                  value: Text(
                                      runtimeVersion.systemVersion.toString(),
                                      style: context.textTheme.titleMedium)),
                              enable: runtimeVersion.systemVersion != null),
                          _NetworkPageKeyValue(
                              name: "genesis_hash".tr,
                              data: controller.substrate.gnesisBlock,
                              value: Text(
                                controller.substrate.gnesisBlock,
                                style: context.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          _NetworkPageKeyValue(
                              name: "rpc_url".tr,
                              data: controller.substrate.endpoint.url,
                              value: Text(
                                controller.substrate.endpoint.url,
                                style: context.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          _NetworkPageKeyValue(
                              name: "metadata_version".tr,
                              data: controller.substrate.runtimeMetadata.version
                                  .toString(),
                              value: Text(
                                controller.substrate.runtimeMetadata.version
                                    .toString(),
                                style: context.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          _NetworkPageKeyValue(
                              data: null,
                              name: "supported_metadata_version".tr,
                              value: AppDropDownBottom(
                                items: {
                                  for (final i in substrate
                                      .runtimeMetadata.supportedVersions)
                                    i: Text("$i")
                                },
                                onChanged: (version) {
                                  if (version == null) return;
                                  controller.switchVersion(version);
                                },
                                value: controller
                                    .substrate.runtimeMetadata.version,
                              )),
                          APPStreamBuilder(
                            stream: block,
                            onProgress: (context) {
                              return _NetworkPageKeyValue(
                                  name: "block_hash".tr,
                                  data: null,
                                  value: Shimmer(
                                      color: context.colors.onSurface
                                          .wOpacity(0.2),
                                      count: 1,
                                      onActive: (context) =>
                                          WidgetConstant.width8,
                                      enable: false));
                            },
                            onData: (context, result) {
                              return _NetworkPageKeyValue(
                                  name: "block_hash".tr,
                                  data: result,
                                  value: Text(result,
                                      style: context.textTheme.titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis));
                            },
                          ),
                        ],
                      )
                    ]),
              ))
        ],
      ),
    );
  }
}

class _NetworkPageKeyValue extends StatelessWidget {
  const _NetworkPageKeyValue(
      {required this.name, required this.value, required this.data});
  final String name;
  final Widget value;
  final String? data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              name,
              style: context.textTheme.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
            Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: value),
                    if (data != null) CopyableTextIcon(text: data!)
                  ],
                )),
          ],
        ),
        WidgetConstant.divider,
      ],
    );
  }
}
