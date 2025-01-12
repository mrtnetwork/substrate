import 'package:substrate/app/tools/func.dart';
import 'package:substrate/app/tools/string_utils.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/substrate/models/chains.dart';
import 'package:flutter/material.dart';

class AddNewChainView extends StatefulWidget {
  const AddNewChainView({this.updateChan, super.key});
  final NetworkInfo? updateChan;

  @override
  State<AddNewChainView> createState() => _AddNewChainViewState();
}

class _AddNewChainViewState extends State<AddNewChainView>
    with SafeState<AddNewChainView> {
  String networkName = '';
  String rpcUrl = '';
  bool immutable = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<PageProgressState> progressKey = GlobalKey();
  void onChangeNetworkName(String name) {
    networkName = name;
  }

  void onChangeUrl(String v) {
    rpcUrl = v;
  }

  String? validateUrl(String? address) {
    final path =
        StrUtils.validateUri(address, schame: ["https", "http", "wss", "ws"]);
    if (path != null) return null;
    return "invalid_url".tr;
  }

  String? validateNetworkName(String? v) {
    if (v?.trim().isEmpty ?? true) return "network_name_validator".tr;
    if (immutable) return null;
    if (controller.chains.any((e) => e.name == v)) {
      return "network_name_exists".tr;
    }
    return null;
  }

  late final APPStateController controller;

  @override
  void onInitOnce() {
    super.onInitOnce();
    controller = context.watch<APPStateController>(APPConst.stateMain);
    networkName = widget.updateChan?.name ?? '';
    if (widget.updateChan != null) {
      immutable = true;
    }
  }

  Future<void> addOrUpdateChain() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    progressKey.progressText("checking_network_connectivity".tr);
    final r = await MethodUtils.call(() async {
      return controller.addNewChain(
          endpoint: RpcEndpoint(name: Uri.parse(rpcUrl).host, url: rpcUrl),
          networkName: widget.updateChan?.name ?? networkName);
    });
    if (r.hasError) {
      progressKey.errorText(r.error!.tr,
          backToIdle: false, showBackButton: true);
    } else {
      progressKey.successText("network_imported".tr, backToIdle: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPageView(
      appBar: AppBar(
        title: ConditionalWidget(
          onActive: (context) => Text("update_chain_provider".tr),
          onDeactive: (context) => Text("add_new_chain".tr),
          enable: immutable,
        ),
      ),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: PageProgress(
          key: progressKey,
          backToIdle: APPConst.oneSecoundDuration,
          child: (context) => Center(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverConstraintsBoxView(
                    padding: WidgetConstant.paddingHorizontal10,
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("network_name".tr,
                              style: context.textTheme.titleMedium),
                          WidgetConstant.height8,
                          AppTextField(
                              label: "network_name".tr,
                              onChanged: onChangeNetworkName,
                              validator: validateNetworkName,
                              readOnly: immutable,
                              initialValue: networkName,
                              pasteIcon: !immutable),
                          WidgetConstant.height20,
                          Text("rpc_url".tr,
                              style: context.textTheme.titleMedium),
                          Text("rpc_url_desc".tr),
                          WidgetConstant.height8,
                          AppTextField(
                            initialValue: rpcUrl,
                            onChanged: onChangeUrl,
                            validator: validateUrl,
                            pasteIcon: true,
                            label: "rpc_url".tr,
                            hint: "wss://example.com.",
                          ),
                          WidgetConstant.height20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FixedElevatedButton(
                                  onPressed: () {
                                    addOrUpdateChain();
                                  },
                                  child: ConditionalWidget(
                                      onActive: (context) =>
                                          Text("update_chain_provider".tr),
                                      onDeactive: (context) =>
                                          Text("add_new_chain".tr),
                                      enable: immutable)),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
