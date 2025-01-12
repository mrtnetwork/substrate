import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/controllers/storage.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/pages/fields/sliver_fields.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/future/widgets/widgets/selectable_text.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class StorageFieldsView extends StatelessWidget {
  const StorageFieldsView(
      {super.key, required this.fields, required this.pallet});
  final List<StorageLookupField> fields;
  final PalletInfo pallet;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPageView(
        appBar: AppBar(title: Text("query_storages".tr)),
        child: StorageFieldsWidget(fields: fields, pallet: pallet));
  }
}

class StorageFieldsWidget extends StatelessWidget {
  const StorageFieldsWidget(
      {required this.fields,
      required this.pallet,
      this.scrollController,
      super.key});
  final List<StorageLookupField> fields;
  final PalletInfo pallet;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    return MrtViewBuilder(
        repositoryId: APPConst.storageState,
        controller: () => StorageFieldsStateController(
            api: controller.substrate, fields: fields, pallet: pallet),
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
                                      for (final form in controller.forms) ...[
                                        SliverToBoxAdapter(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (form == null) ...[
                                                Text("inputs_not_needed".tr),
                                                WidgetConstant.divider
                                              ],
                                            ],
                                          ),
                                        ),
                                        if (form != null) ...[
                                          FormField(validator: (value) {
                                            return form.error;
                                          }, builder: (context) {
                                            return SliverFieldValidatorView(
                                                validator: form);
                                          }),
                                          const SliverToBoxAdapter(
                                              child: WidgetConstant.divider),
                                        ],
                                      ],
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
                                                child: Text("get_storage".tr)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                              true: (context) => SliverMainAxisGroup(
                                    slivers: [
                                      SliverList.separated(
                                        itemCount: controller.fields.length,
                                        separatorBuilder: (context, index) =>
                                            WidgetConstant.divider,
                                        itemBuilder: (context, index) {
                                          final result =
                                              controller.results[index];
                                          final storage =
                                              controller.fields[index].storage;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(storage.name,
                                                  style: context
                                                      .textTheme.titleMedium),
                                              WidgetConstant.height8,
                                              ContainerWithBorder(
                                                  child: CopyableTextWidget(
                                                      text: result,
                                                      color: context
                                                          .onPrimaryContainer,
                                                      widget: APPSelectableText(
                                                          result,
                                                          style: context
                                                              .onPrimaryTextTheme
                                                              .bodyMedium),
                                                      maxLines: 10)),
                                            ],
                                          );
                                        },
                                      ),
                                      SliverToBoxAdapter(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FixedElevatedButton(
                                                padding: WidgetConstant
                                                    .paddingVertical40,
                                                onPressed: () {
                                                  controller.cleanUpState();
                                                },
                                                child: Text("query_again".tr)),
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
