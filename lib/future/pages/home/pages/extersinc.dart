import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/metadata.dart';
import 'package:substrate/future/controllers/extrinsic_payload.dart';
import 'package:substrate/future/pages/fields/sliver_fields.dart';
import 'package:substrate/future/pages/quick_access/quick_access_view.dart';
import 'package:substrate/future/pages/signature/generate_signature.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/future/widgets/widgets/tooltip_view.dart';
import 'package:substrate/future/widgets/widgets/unfocusable.dart';
import 'package:substrate/substrate/models/extrinsic.dart';
import 'package:flutter/material.dart';

class HomeExtrinsicAccess extends StatelessWidget {
  const HomeExtrinsicAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return MrtViewBuilder(
        controller: () => ExtrinsicPayloadFieldsStateController(
            appController:
                context.watch<APPStateController>(APPConst.stateMain)),
        repositoryId: APPConst.extrinsicState,
        removable: false,
        builder: (controller) {
          return Scaffold(
            appBar: controller.page == ExtrinsicPage.createPayload
                ? null
                : AppBar(
                    title: Text(controller.page.name.tr),
                    leading: IconButton(
                        onPressed: () {
                          controller.onBackButton();
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.openDialogPage(
                    'quick_access'.tr,
                    child: (context) {
                      return const QuickAccessView();
                    },
                  );
                },
                child: const Icon(Icons.build)),
            body: Form(
              key: controller.formState,
              child: UnfocusableChild(
                child: PageProgress(
                  key: controller.progressKey,
                  backToIdle: APPConst.oneSecoundDuration,
                  initialStatus: StreamWidgetStatus.progress,
                  child: (context) => Center(
                    child: CustomScrollView(
                      slivers: [
                        if (controller.extrinsicValidators == null)
                          SliverPinnedHeaderSurface(
                            child: ErrorTextContainer(
                                enableTap: false,
                                error: "create_extrinsics_v14_desc".tr),
                          ),
                        SliverConstraintsBoxView(
                            padding: WidgetConstant.paddingHorizontal10,
                            sliver: APPSliverAnimatedSwitcher<ExtrinsicPage>(
                                enable: controller.page,
                                widgets: {
                                  ExtrinsicPage.createPayload: (context) =>
                                      _CreatePayload(controller: controller),
                                  ExtrinsicPage.showPayload: (context) =>
                                      _CreatedPayloadInfo(
                                          controller: controller),
                                  ExtrinsicPage.createExtrinsic: (context) =>
                                      _CreateExtrinsic(controller: controller),
                                  ExtrinsicPage.showExtrinsic: (context) =>
                                      _ShowFinalExtrinsic(
                                          controller: controller)
                                })),
                        WidgetConstant.sliverPaddingVertial40
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _CreateExtrinsic extends StatelessWidget {
  ExtrinsicPayloadInfo get payload => controller.payloadInfo;
  List<MetadataFormValidator>? get forms => controller.extrinsicValidators;
  final ExtrinsicPayloadFieldsStateController controller;
  const _CreateExtrinsic({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(slivers: [
      _ShowPayloadInfo(payload),
      if (forms != null)
        ...forms!.map((i) => FormField(validator: (value) {
              return i.error;
            }, builder: (context) {
              return SliverFieldValidatorView(validator: i);
            })),
      SliverToBoxAdapter(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (forms == null)
          Expanded(
              child: ErrorTextContainer(
                  error: "address_signature_field_not_found_desc".tr))
        else
          FixedElevatedButton(
              padding: WidgetConstant.paddingVertical40,
              onPressed: () {
                controller.createExtrinsic();
              },
              child: Text("create_extrinsic".tr))
      ]))
    ]);
  }
}

class _CreatePayload extends StatelessWidget {
  List<MetadataFormValidator> get forms =>
      controller.extrinsicPayloadValidators;
  final ExtrinsicPayloadFieldsStateController controller;
  const _CreatePayload({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(slivers: [
      SliverPinnedHeaderSurface(
        elevation: APPConst.elevation,
        child: Column(
          children: [
            ExpansionTile(
                initiallyExpanded: true,
                title: Text("finaliz_block".tr),
                children: [
                  ContainerWithBorder(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("finaliz_block".tr,
                                    style:
                                        context.onPrimaryTextTheme.titleMedium),
                                Text("quick_era".tr),
                              ],
                            )),
                            TappedTooltipView(
                              tooltipWidget: ToolTipView(
                                message: 'extersinc_auto_validate_desc'.tr,
                                child: Icon(Icons.help),
                              ),
                            ),
                            WidgetConstant.width8,
                            IconButton(
                                onPressed: controller.updateFinalizBlock,
                                icon: Icon(Icons.refresh))
                          ],
                        ),
                        WidgetConstant.height8,
                        ContainerWithBorder(
                          backgroundColor: context.onPrimaryContainer,
                          onRemove: () {},
                          enableTap: false,
                          onRemoveWidget: CopyableTextIcon(
                            text: controller.blockWithEra!.hash,
                            color: context.primaryContainer,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.blockWithEra!.hash,
                                style: context.primaryTextTheme.bodyMedium,
                              ),
                              Text(controller.blockWithEra!.era.toString(),
                                  style: context.primaryTextTheme.bodySmall)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ],
        ),
      ),
      ...forms.map((i) => FormField(validator: (value) {
            return i.error;
          }, builder: (context) {
            return SliverFieldValidatorView(validator: i);
          })),
      SliverToBoxAdapter(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FixedElevatedButton(
            padding: WidgetConstant.paddingVertical40,
            onPressed: () {
              controller.createPayload();
            },
            child: Text("create_payload".tr))
      ]))
    ]);
  }
}

class _CreatedPayloadInfo extends StatelessWidget {
  ExtrinsicPayloadInfo get payload => controller.payloadInfo;
  final ExtrinsicPayloadFieldsStateController controller;
  const _CreatedPayloadInfo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(slivers: [
      _ShowPayloadInfo(payload),
      SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FixedElevatedButton(
                padding: WidgetConstant.paddingVertical40,
                onPressed: () {
                  context
                      .openSliverBottomSheet<ExtrinsicPayloadInfo>(
                        "sign_payload".tr,
                        bodyBuilder: (sc) => GenerateSignatureView(
                            payload: payload, scrollController: sc),
                      )
                      .then(controller.updatePayload);
                },
                child: Text("sing_and_setup_extrinsic".tr)),
          ],
        ),
      ),
    ]);
  }
}

class _ShowPayloadInfo extends StatelessWidget {
  final ExtrinsicPayloadInfo payload;
  const _ShowPayloadInfo(this.payload);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("payload_info".tr, style: context.textTheme.titleMedium),
          WidgetConstant.height8,
          ContainerWithBorder(
              child: CopyableTextWidget(
                  text: payload.payloadInfo,
                  color: context.onPrimaryContainer,
                  widget: SelectableText(payload.payloadInfo,
                      maxLines: 10,
                      minLines: 1,
                      style: context.onPrimaryTextTheme.bodyMedium),
                  maxLines: 10)),
          WidgetConstant.height20,
          Text("serialized_data".tr, style: context.textTheme.titleMedium),
          WidgetConstant.height8,
          ContainerWithBorder(
              child: CopyableTextWidget(
                  text: payload.serializedExtrinsic,
                  color: context.onPrimaryContainer,
                  widget: SelectableText(payload.serializedExtrinsic,
                      maxLines: 2,
                      minLines: 1,
                      style: context.onPrimaryTextTheme.bodyMedium),
                  maxLines: 2)),
          WidgetConstant.height20,
          Text("serialized_call".tr, style: context.textTheme.titleMedium),
          WidgetConstant.height8,
          ContainerWithBorder(
              child: CopyableTextWidget(
                  text: payload.method,
                  color: context.onPrimaryContainer,
                  widget: SelectableText(payload.method,
                      maxLines: 2,
                      minLines: 1,
                      style: context.onPrimaryTextTheme.bodyMedium),
                  maxLines: 2)),
          WidgetConstant.height20,
          ConditionalWidget(
              enable: payload.payload != payload.serializedExtrinsic,
              onActive: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("payload".tr,
                            style: context.textTheme.titleMedium),
                        Text("serialized_data_hash".tr),
                        WidgetConstant.height8,
                        ContainerWithBorder(
                            child: CopyableTextWidget(
                                text: payload.payload,
                                color: context.onPrimaryContainer,
                                widget: SelectableText(payload.payload,
                                    maxLines: 2,
                                    minLines: 1,
                                    style:
                                        context.onPrimaryTextTheme.bodyMedium),
                                maxLines: 2)),
                        WidgetConstant.height20,
                      ])),
          ConditionalWidget(
              onActive: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("signature".tr,
                            style: context.textTheme.titleMedium),
                        WidgetConstant.height8,
                        ContainerWithBorder(
                            child: CopyableTextWidget(
                                text: payload.signature!.signature,
                                color: context.onPrimaryContainer,
                                widget: SelectableText(
                                    payload.signature!.signature,
                                    maxLines: 2,
                                    minLines: 1,
                                    style:
                                        context.onPrimaryTextTheme.bodyMedium),
                                maxLines: 2)),
                        WidgetConstant.height20,
                      ]),
              enable: payload.signature != null)
        ],
      ),
    );
  }
}

class _ShowFinalExtrinsic extends StatelessWidget {
  ExtrinsicInfo? get payload => controller.extrinsicInfo;
  final ExtrinsicPayloadFieldsStateController controller;
  const _ShowFinalExtrinsic({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (payload == null) return WidgetConstant.sliverSizedBox;
    return SliverMainAxisGroup(slivers: [
      _ShowPayloadInfo(payload!.payload),
      SliverToBoxAdapter(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("extrinsic".tr, style: context.textTheme.titleMedium),
          WidgetConstant.height8,
          ContainerWithBorder(
              child: CopyableTextWidget(
                  text: payload!.serializedExtrinsic,
                  color: context.onPrimaryContainer,
                  widget: SelectableText(payload!.serializedExtrinsic,
                      maxLines: 2,
                      minLines: 1,
                      style: context.onPrimaryTextTheme.bodyMedium),
                  maxLines: 2)),
          WidgetConstant.height20,
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FixedElevatedButton(
                padding: WidgetConstant.paddingVertical40,
                onPressed: () {
                  controller.broadcastTx();
                },
                child: Text("broadcast_extrinsic".tr))
          ]),
        ],
      ))
    ]);
  }
}
