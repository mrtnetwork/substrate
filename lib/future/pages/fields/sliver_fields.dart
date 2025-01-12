import 'package:blockchain_utils/utils/utils.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/forms/models/metadata.dart';
import 'package:substrate/future/pages/quick_access/constants.dart';
import 'package:substrate/future/pages/quick_access/runtime_apis.dart';
import 'package:substrate/future/pages/quick_access/storage.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/future/widgets/widgets/bytes_tools.dart';
import 'package:substrate/future/widgets/widgets/utf8_decoder.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class SliverFieldValidatorView extends StatelessWidget {
  const SliverFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidator validator;
  @override
  Widget build(BuildContext context) {
    return switch (validator.runtimeType) {
      const (MetadataFormValidatorBoolean) =>
        BooleanFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorString) =>
        StringFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorInt) =>
        NumericFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorBigInt) =>
        NumericFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorNone) =>
        NoneFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorTuple) =>
        TupleFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorComposit) =>
        CompositFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorSequence) =>
        SequenceFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorVariant) =>
        VariantFieldValidatorView(validator: validator.cast()),
      const (MetadataFormValidatorBytes) =>
        BytesFieldValidatorView(validator: validator.cast()),
      _ => SliverToBoxAdapter(
          child: ContainerWithBorder(
              child: Text("unknow! ${validator.toString()}")))
    };
  }
}

class BooleanFieldValidatorView extends StatelessWidget {
  const BooleanFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorBoolean validator;
  @override
  Widget build(BuildContext context) {
    return LiveWidget(
      () {
        return SliverMainAxisGroup(
          slivers: [
            WidgetConstant.sliverPaddingVertial10,
            SliverFieldNameView(validator.info),
            _Wrap(
              field: validator,
              child: ContainerWithBorder(
                  validate: validator.isValid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("false".tr),
                      WidgetConstant.width8,
                      Switch(
                          value: validator.value.value ?? false,
                          onChanged: validator.setValue),
                      WidgetConstant.width8,
                      Text("true".tr)
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }
}

enum QuickAccessOptions {
  storage("storages"),
  runtimeApi("runtime_apis"),
  constants("constants"),
  utf8Encoder("utf8_encoder"),
  transactionVersion("transaction_version"),
  specVersion("spec_version"),
  addressDecoder("address_decoder"),
  genesisHash("genesis_hash"),
  bytesTools("bytes_tools"),
  pow7("7^10"),
  pow10("10^10"),
  pow12("12^10"),
  pow18("18^10");

  static QuickAccessOptions? fromScale(int? pow) {
    switch (pow) {
      case 7:
        return QuickAccessOptions.pow7;
      case 10:
        return QuickAccessOptions.pow10;
      case 12:
        return QuickAccessOptions.pow12;
      case 18:
        return QuickAccessOptions.pow18;
      default:
        return null;
    }
  }

  static List<QuickAccessOptions> globalOptions(APPStateController controller) {
    return [
      QuickAccessOptions.constants,
      QuickAccessOptions.storage,
      if (controller.substrate.supportRuntimeApi) QuickAccessOptions.runtimeApi,
    ];
  }

  final String name;
  const QuickAccessOptions(this.name);
}

class NumericFieldValidatorView extends StatelessWidget {
  const NumericFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorNumeric validator;
  @override
  Widget build(BuildContext context) {
    return LiveWidget(() {
      return SliverMainAxisGroup(
        slivers: [
          WidgetConstant.sliverPaddingVertial10,
          SliverFieldNameView(validator.info),
          _Wrap(
            field: validator,
            child: ContainerWithBorder(
                validate: validator.isValid,
                onRemove: () {},
                enableTap: false,
                onRemoveWidget: QuickAccessPopupMenuButton(
                    checked: QuickAccessOptions.fromScale(validator.maxScale),
                    icon: ConditionalWidget(
                      onActive: (context) => Text("${validator.maxScale}^10",
                          style: context.onPrimaryTextTheme.labelLarge),
                      enable: validator.maxScale != null,
                      onDeactive: (context) =>
                          Icon(Icons.menu, color: context.onPrimaryContainer),
                    ),
                    onselectoption: (value) {
                      final controller =
                          context.watch<APPStateController>(APPConst.stateMain);
                      switch (value) {
                        case QuickAccessOptions.transactionVersion:
                          validator.setValue(BigRational.from(controller
                              .substrate.runtimeVersion.transactionVersion));
                          break;
                        case QuickAccessOptions.specVersion:
                          final specVersion = BigRational.from(
                              controller.substrate.runtimeVersion.specVersion);
                          validator.setValue(specVersion);
                          break;
                        case QuickAccessOptions.pow10:
                        case QuickAccessOptions.pow7:
                        case QuickAccessOptions.pow12:
                        case QuickAccessOptions.pow18:
                          final pow = int.parse(value.name.split("^")[0]);
                          validator.setPow(pow);
                          break;
                        default:
                          break;
                      }
                    },
                    option: QuickAccessType.numbers),
                child: BigRationalTextField(
                    label: validator.info.viewName ?? '',
                    onChange: validator.setValue,
                    defaultValue: validator.value.value,
                    validator: validator.validate,
                    maxScale: validator.maxScale,
                    max: validator.max,
                    min: validator.min)),
          ),
        ],
      );
    });
  }
}

class NoneFieldValidatorView extends StatelessWidget {
  const NoneFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorNone validator;
  @override
  Widget build(BuildContext context) {
    return WidgetConstant.sliverSizedBox;
  }
}

class StringFieldValidatorView extends StatelessWidget {
  const StringFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorString validator;
  @override
  Widget build(BuildContext context) {
    return LiveWidget(() {
      return SliverMainAxisGroup(
        slivers: [
          WidgetConstant.sliverPaddingVertial10,
          SliverFieldNameView(validator.info),
          _Wrap(
            field: validator,
            child: ContainerWithBorder(
              validate: validator.isValid,
              onRemove: () {
                context
                    .openSliverBottomSheet<String>(
                      validator.info.viewName ?? 'input_string'.tr,
                      child: StringWriterView(
                          defaultValue: validator.value.value,
                          title: Text("string".tr),
                          label: "string".tr,
                          buttonText: 'setup'.tr),
                    )
                    .then(validator.setValue);
              },
              onRemoveIcon:
                  Icon(Icons.add_box, color: context.onPrimaryContainer),
              child: ValueOrTapInputValue(value: validator.value.value),
            ),
          ),
        ],
      );
    });
  }
}

class BytesFieldValidatorView extends StatelessWidget {
  const BytesFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorBytes validator;
  @override
  Widget build(BuildContext context) {
    return LiveWidget(() {
      return SliverMainAxisGroup(
        slivers: [
          WidgetConstant.sliverPaddingVertial10,
          SliverFieldNameView(validator.info),
          _Wrap(
            field: validator,
            child: ContainerWithBorder(
              validate: validator.isValid,
              onRemove: () {},
              enableTap: false,
              onRemoveWidget: QuickAccessPopupMenuButton(
                  onselectoption: (value) async {
                    final controller =
                        context.watch<APPStateController>(APPConst.stateMain);
                    switch (value) {
                      case QuickAccessOptions.addressDecoder:
                        final r = await context.openSliverBottomSheet<String>(
                            'address_decoder'.tr,
                            child: const AddressDecoderView());
                        if (r == null) return;
                        validator.setValue(r);
                        break;
                      case QuickAccessOptions.genesisHash:
                        validator.setValue(controller.substrate.gnesisBlock);
                        break;
                      case QuickAccessOptions.utf8Encoder:
                        final r = await context.openSliverBottomSheet<String>(
                            'utf8_encoder'.tr,
                            child: const UTF8EncoderView());
                        if (r == null) return;
                        validator.setValue(r);
                        break;
                      default:
                        break;
                    }
                  },
                  option: QuickAccessType.bytes),
              child: AppTextField(
                  maxLines: 3,
                  minlines: 1,
                  validator: validator.validate,
                  onChanged: validator.setValue,
                  label: validator.type.viewName ?? "bytes".tr,
                  pasteIcon: true,
                  initialValue: validator.value),
            ),
          ),
        ],
      );
    });
  }
}

class SequenceFieldValidatorView extends StatelessWidget {
  const SequenceFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorSequence validator;
  @override
  Widget build(BuildContext context) {
    return LiveWidget(() {
      final List<MetadataFormValidator> validators = validator.validators;
      return SliverMainAxisGroup(slivers: [
        ...List.generate(
          validators.length,
          (index) {
            final v = validators[index];
            return SliverFieldValidatorView(validator: v);
          },
        ),
        _Wrap(
          field: validator,
          child: ConditionalWidgets(enable: validator.immutable, widgets: {
            true: (context) => WidgetConstant.sizedBox,
            false: (context) => ContainerWithBorder(
                  onRemove: () {
                    validator.add();
                  },
                  onRemoveIcon:
                      Icon(Icons.add_box, color: context.onPrimaryContainer),
                  child: Text("tap_to_create_object"
                      .tr
                      .replaceOne(validator.info.viewName ?? '')),
                )
          }),
        )
      ]);
    });
  }
}

class TupleFieldValidatorView extends StatelessWidget {
  const TupleFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorTuple validator;
  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        ...List.generate(validator.validators.length, (index) {
          final field = validator.validators[index];
          return SliverFieldValidatorView(validator: field);
        }),
      ],
    );
  }
}

class CompositFieldValidatorView extends StatelessWidget {
  const CompositFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorComposit validator;
  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        ...List.generate(validator.validators.length, (index) {
          final field = validator.validators[index];
          return SliverFieldValidatorView(validator: field);
        })
      ],
    );
  }
}

class VariantFieldValidatorView extends StatelessWidget {
  const VariantFieldValidatorView({required this.validator, super.key});
  final MetadataFormValidatorVariant validator;
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    return LiveWidget(() {
      return SliverMainAxisGroup(
        slivers: [
          WidgetConstant.sliverPaddingVertial10,
          SliverFieldNameView(validator.info),
          _Wrap(
            field: validator,
            child: ContainerWithBorder(
              validate: validator.isValid,
              child: AppDropDownBottom(
                  isExpanded: true,
                  items: {
                    for (final i in validator.info.variants)
                      i: Text(i.name, style: context.textTheme.titleMedium),
                  },
                  onChanged: (variant) {
                    if (variant == null) return;
                    validator.setVariant(
                        variant: variant,
                        type: controller.substrate.getTypeInfo(variant).cast());
                  },
                  value: validator.variant,
                  hint: validator.info.viewName),
            ),
          ),
          APPSliverAnimatedSwitcher(enable: validator.hasVariant, widgets: {
            true: (context) => SliverPadding(
                  padding: WidgetConstant.paddingHorizontal5,
                  sliver: SliverFieldValidatorView(
                      key: ValueKey<Si1Variant?>(validator.variant),
                      validator: validator.validator!),
                )
          }),
        ],
      );
    });
  }
}

class _WrapSliver extends StatelessWidget {
  const _WrapSliver({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: child);
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap({required this.field, required this.child});
  final MetadataFormValidator field;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (field.onRemove == null) return _WrapSliver(child: child);
    return _WrapSliver(
      child: ContainerWithBorder(
          onRemoveWidget:
              Icon(Icons.remove_circle, color: context.colors.onSurface),
          onRemove: field.onRemove,
          backgroundColor: context.colors.surface,
          child: child),
    );
  }
}

typedef ONSELECTOPTION = void Function(QuickAccessOptions);

enum QuickAccessType {
  numbers,
  bytes;

  List<QuickAccessOptions> options(APPStateController controller) {
    switch (this) {
      case QuickAccessType.numbers:
        return [
          QuickAccessOptions.transactionVersion,
          QuickAccessOptions.specVersion,
          QuickAccessOptions.pow10,
          QuickAccessOptions.pow12,
          QuickAccessOptions.pow18,
        ];
      case QuickAccessType.bytes:
        return [
          QuickAccessOptions.addressDecoder,
          QuickAccessOptions.genesisHash,
          QuickAccessOptions.utf8Encoder,
          QuickAccessOptions.bytesTools
        ];
    }
  }
}

class QuickAccessPopupMenuButton extends StatelessWidget {
  const QuickAccessPopupMenuButton(
      {required this.onselectoption,
      required this.option,
      this.checked,
      this.icon,
      super.key});
  final QuickAccessType option;
  final ONSELECTOPTION onselectoption;
  final Widget? icon;
  final QuickAccessOptions? checked;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<APPStateController>(APPConst.stateMain);
    return PopupMenuButton<QuickAccessOptions>(
      icon: icon ?? Icon(Icons.menu, color: context.onPrimaryContainer),
      itemBuilder: (context) {
        final List<PopupMenuEntry<QuickAccessOptions>> options = [
          ...QuickAccessOptions.globalOptions(controller)
              .map((e) => PopupMenuItem(value: e, child: Text(e.name.tr))),
          const PopupMenuDivider(),
          ...option.options(controller).map((e) {
            switch (e) {
              case QuickAccessOptions.pow7:
              case QuickAccessOptions.pow10:
              case QuickAccessOptions.pow18:
              case QuickAccessOptions.pow12:
                return CheckedPopupMenuItem(
                    value: e, checked: e == checked, child: Text(e.name.tr));
              default:
            }
            return PopupMenuItem(value: e, child: Text(e.name.tr));
          })
        ];
        return options;
      },
      onSelected: (value) async {
        switch (value) {
          case QuickAccessOptions.constants:
            context.openSliverBottomSheet('constants'.tr,
                bodyBuilder: (controller) =>
                    QuickConstantsAccess(scrollController: controller));
            break;
          case QuickAccessOptions.storage:
            context.openSliverBottomSheet('storages'.tr,
                bodyBuilder: (controller) =>
                    QuickStorageAccess(scrollController: controller));
            break;
          case QuickAccessOptions.runtimeApi:
            context.openSliverBottomSheet('runtime_apis'.tr,
                bodyBuilder: (controller) =>
                    QuickRuntimeAPIAccess(scrollController: controller));
            break;
          case QuickAccessOptions.bytesTools:
            context.openSliverBottomSheet('bytes_tools'.tr,
                child: const BytesToolsView());
            break;
          default:
            onselectoption(value);
        }
      },
    );
  }
}

class ValueOrTapInputValue extends StatelessWidget {
  const ValueOrTapInputValue({super.key, this.value, this.maxLine = 3});
  final String? value;
  final int maxLine;
  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
        onActive: (context) => Text(value!,
            style: context.onPrimaryTextTheme.bodyMedium, maxLines: maxLine),
        onDeactive: (context) => Text("tap_to_input_value".tr,
            style: context.onPrimaryTextTheme.bodyMedium),
        enable: value != null);
  }
}

class FieldNameView extends StatelessWidget {
  const FieldNameView(this.type, {super.key});
  final MetadataTypeInfo type;

  @override
  Widget build(BuildContext context) {
    if (type.viewName == null) return WidgetConstant.sizedBox;
    return Column(
      children: [
        ConditionalWidgets(enable: type.viewName == null, widgets: {
          true: (context) => WidgetConstant.sizedBox,
          false: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.viewName!, style: context.textTheme.titleMedium),
                  WidgetConstant.height8
                ],
              ),
        }),
      ],
    );
  }
}

class SliverFieldNameView extends StatelessWidget {
  const SliverFieldNameView(this.type, {super.key});
  final MetadataTypeInfo type;

  @override
  Widget build(BuildContext context) {
    return ConditionalWidgets(enable: type.viewName == null, widgets: {
      true: (context) => WidgetConstant.sliverSizedBox,
      false: (context) => SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.viewName!, style: context.textTheme.titleMedium),
                WidgetConstant.height8
              ],
            ),
          ),
    });
  }
}
