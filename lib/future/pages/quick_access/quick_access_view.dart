import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/pages/quick_access/constants.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/copyable_text.dart';
import 'package:substrate/future/widgets/widgets/future_builder.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/widgets/circular_progress_indicator.dart';
import 'package:substrate/future/widgets/widgets/tile.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

import 'runtime_apis.dart';
import 'storage.dart';

class QuickAccessView extends StatefulWidget {
  const QuickAccessView({super.key});

  @override
  State<QuickAccessView> createState() => _QuickAccessViewState();
}

class _QuickAccessViewState extends State<QuickAccessView>
    with SafeState<QuickAccessView> {
  late final APPStateController stateController;
  SubstrateApi get api => stateController.substrate;
  StorageInfo? accountInfoKey;

  @override
  void onInitOnce() {
    super.onInitOnce();
    stateController = context.watch<APPStateController>(APPConst.stateMain);
    accountInfoKey = api.getAccountInfoStorageKey();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: WidgetConstant.paddingHorizontal10,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppListTile(
                title: Text("constants".tr),
                trailing: const Icon(Icons.open_in_new_outlined),
                onTap: () {
                  context.openSliverBottomSheet('constants'.tr,
                      bodyBuilder: (controller) =>
                          QuickConstantsAccess(scrollController: controller));
                },
              ),
              AppListTile(
                title: Text("storages".tr),
                trailing: const Icon(Icons.open_in_new_outlined),
                onTap: () {
                  context.openSliverBottomSheet('storages'.tr,
                      bodyBuilder: (controller) =>
                          QuickStorageAccess(scrollController: controller));
                },
              ),
              if (stateController.substrate.supportRuntimeApi)
                AppListTile(
                  title: Text("runtime_apis".tr),
                  trailing: const Icon(Icons.open_in_new_outlined),
                  onTap: () {
                    context.openSliverBottomSheet('runtime_apis'.tr,
                        bodyBuilder: (controller) => QuickRuntimeAPIAccess(
                            scrollController: controller));
                  },
                ),
              if (accountInfoKey != null)
                AppListTile(
                  title: Text("account_info".tr),
                  trailing: const Icon(Icons.open_in_new_outlined),
                  subtitle: Text("account_info_desc".tr),
                  onTap: () {
                    context.openSliverBottomSheet('account_info'.tr,
                        bodyBuilder: (controller) => QuickStorageAccess(
                              scrollController: controller,
                              storage: accountInfoKey,
                            ));
                  },
                ),
              WidgetConstant.divider,
              APPFutureBuilder(
                  onData: (context, result) {
                    final blockHash = result.toHex();
                    return CopyableTextWidget(
                        text: blockHash,
                        widget: AppListTile(
                            subtitle: Text(blockHash),
                            title: Text("block_hash".tr,
                                style: context.textTheme.titleMedium)));
                  },
                  onError: (context, err) {
                    return AppListTile(
                        title: Text("block_hash".tr),
                        trailing: Tooltip(
                            message: err.toString(),
                            child: WidgetConstant.errorIcon));
                  },
                  onProgress: (context) {
                    return AppListTile(
                        title: Text("block_hash".tr),
                        trailing: const APPCircularProgressIndicator());
                  },
                  future: api.client.getBlockHash()),
              APPFutureBuilder(
                  onData: (context, result) {
                    // final blockHash = result.toHex();
                    return Column(
                      children: [
                        CopyableTextWidget(
                            text: result.hash,
                            widget: AppListTile(
                                subtitle: Text(result.hash),
                                title: Text("finaliz_block".tr,
                                    style: context.textTheme.titleMedium))),
                        CopyableTextWidget(
                            text: result.era.toString(),
                            widget: AppListTile(
                                subtitle: Text(result.era.toString()),
                                title: Text("quick_era".tr,
                                    style: context.textTheme.titleMedium)))
                      ],
                    );
                  },
                  onError: (context, err) {
                    return AppListTile(
                        title: Text("finaliz_block_era".tr),
                        trailing: Tooltip(
                            message: err.toString(),
                            child: WidgetConstant.errorIcon));
                  },
                  onProgress: (context) {
                    return AppListTile(
                        title: Text("finaliz_block_era".tr),
                        trailing: const APPCircularProgressIndicator());
                  },
                  future: api.client.blockWithEra()),
              CopyableTextWidget(
                  text: api.gnesisBlock,
                  widget: AppListTile(
                      subtitle: Text(api.gnesisBlock),
                      title: Text("genesis_hash".tr,
                          style: context.textTheme.titleMedium))),
              CopyableTextWidget(
                text: api.runtimeVersion.specVersion.toString(),
                widget: AppListTile(
                    subtitle: Text(api.runtimeVersion.specVersion.toString()),
                    title: Text("spec_version".tr,
                        style: context.textTheme.titleMedium)),
              ),
              CopyableTextWidget(
                text: api.runtimeVersion.transactionVersion.toString(),
                widget: AppListTile(
                    subtitle:
                        Text(api.runtimeVersion.transactionVersion.toString()),
                    title: Text("transaction_version".tr,
                        style: context.textTheme.titleMedium)),
              ),
            ]),
      ),
    );
  }
}
