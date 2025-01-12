import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/controllers/runtime_api.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/future/widgets/widgets/selectable_text.dart';
import 'package:flutter/material.dart';
import 'sliver_fields.dart';

class RuntimeAPIsFieldsView extends StatelessWidget {
  const RuntimeAPIsFieldsView({super.key, required this.field});
  final RuntimeMethodLookupField field;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPageView(
      appBar: AppBar(
          title: Text("two_n"
              .tr
              .replaceOne(field.apiName)
              .replaceTwo(field.method.viewName))),
      child: RuntimeAPIsFieldsWidget(field: field),
    );
  }
}

class RuntimeAPIsFieldsWidget extends StatelessWidget {
  const RuntimeAPIsFieldsWidget(
      {super.key, this.scrollController, required this.field});
  final RuntimeMethodLookupField field;
  final ScrollController? scrollController;
  // final SubstrateApi api;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);

    return MrtViewBuilder(
        controller: () => RuntimeApiFieldsStateController(
            api: controller.substrate, field: field),
        repositoryId: field.apiName,
        builder: (controller) {
          return Form(
            key: controller.formState,
            child: PageProgress(
              key: controller.progressKey,
              backToIdle: APPConst.oneSecoundDuration,
              child: (context) => Center(
                child: CustomScrollView(
                  controller: scrollController,
                  shrinkWrap: true,
                  slivers: [
                    SliverConstraintsBoxView(
                        padding: WidgetConstant.paddingHorizontal10,
                        sliver: APPSliverAnimatedSwitcher(
                            enable: controller.showResult,
                            widgets: {
                              false: (context) => SliverMainAxisGroup(
                                    slivers: [
                                      if (controller.forms.isEmpty)
                                        SliverToBoxAdapter(
                                            child:
                                                Text("inputs_not_needed".tr)),
                                      for (final form in controller.forms)
                                        FormField(validator: (value) {
                                          return form.error;
                                        }, builder: (context) {
                                          return SliverFieldValidatorView(
                                              validator: form);
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
                                                  controller.callStorage();
                                                },
                                                child: Text("call_api".tr)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                              true: (context) => SliverToBoxAdapter(
                                    child: Column(
                                      children: [
                                        ContainerWithBorder(
                                            child: CopyableTextWidget(
                                          text: controller.result ?? '',
                                          color: context.onPrimaryContainer,
                                          widget: APPSelectableText(
                                              controller.result ?? '',
                                              style: context.onPrimaryTextTheme
                                                  .bodyMedium),
                                          maxLines: 10,
                                        )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FixedElevatedButton.icon(
                                                padding: WidgetConstant
                                                    .paddingVertical40,
                                                onPressed: () {
                                                  controller.cleanUpState();
                                                },
                                                label: Text("call_again".tr),
                                                icon:
                                                    const Icon(Icons.refresh)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                            })),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
