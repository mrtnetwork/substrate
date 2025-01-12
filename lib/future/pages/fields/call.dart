import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/controllers/call.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/pages/fields/sliver_fields.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/future/widgets/widgets/selectable_text.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class CallFieldsView extends StatelessWidget {
  const CallFieldsView({super.key, required this.fields, required this.pallet});
  final CallLookupField fields;
  final PalletInfo pallet;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPageView(
        appBar: AppBar(title: Text("query_storages".tr)),
        child: CallFieldsWidget(fields: fields, pallet: pallet));
  }
}

class CallFieldsWidget extends StatelessWidget {
  const CallFieldsWidget(
      {required this.fields,
      required this.pallet,
      this.scrollController,
      super.key});
  final CallLookupField fields;
  final PalletInfo pallet;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    return MrtViewBuilder(
        repositoryId: APPConst.callFields,
        controller: () => CallFieldsStateController(
            api: controller.substrate, field: fields, pallet: pallet),
        builder: (controller) {
          return Form(
            key: controller.formState,
            child: PageProgress(
              key: controller.progressKey,
              backToIdle: APPConst.oneSecoundDuration,
              child: (context) => Center(
                child: CustomScrollView(
                  shrinkWrap: true,
                  controller: scrollController,
                  slivers: [
                    SliverConstraintsBoxView(
                        padding: WidgetConstant.paddingHorizontal10,
                        sliver: APPSliverAnimatedSwitcher(
                            enable: controller.showResult,
                            widgets: {
                              false: (context) => SliverMainAxisGroup(
                                    slivers: [
                                      FormField(validator: (value) {
                                        return controller.form.error;
                                      }, builder: (context) {
                                        return SliverFieldValidatorView(
                                            validator: controller.form);
                                      }),
                                      SliverToBoxAdapter(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FixedElevatedButton(
                                                padding: WidgetConstant
                                                    .paddingVertical40,
                                                onPressed: () {
                                                  controller.encodeCall();
                                                },
                                                child: Text("encode_call".tr)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                              true: (context) => SliverMainAxisGroup(
                                    slivers: [
                                      SliverToBoxAdapter(
                                          child: ContainerWithBorder(
                                              child: CopyableTextWidget(
                                        text: controller.encodedData!,
                                        color: context.onPrimaryContainer,
                                        widget: APPSelectableText(
                                            controller.encodedData!,
                                            style: context
                                                .onPrimaryTextTheme.bodyMedium),
                                        maxLines: 10,
                                      ))),
                                      SliverToBoxAdapter(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FixedElevatedButton(
                                                padding: WidgetConstant
                                                    .paddingVertical40,
                                                onPressed: () {
                                                  controller.clearState();
                                                },
                                                child: Text("encode_again".tr)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                            }))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
