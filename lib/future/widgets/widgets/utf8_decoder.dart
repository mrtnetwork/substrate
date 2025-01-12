import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_size.dart';
import 'package:substrate/future/widgets/widgets/container.dart';
import 'package:substrate/future/widgets/widgets/copyable_text.dart';
import 'package:flutter/widgets.dart';
import 'button.dart';
import 'constant.dart';
import 'paste_icon.dart';
import 'text_field.dart';

class UTF8EncoderView extends StatefulWidget {
  const UTF8EncoderView({super.key});

  @override
  State<UTF8EncoderView> createState() => _UTF8EncoderViewState();
}

class _UTF8EncoderViewState extends State<UTF8EncoderView>
    with SafeState<UTF8EncoderView> {
  String? inHex;

  final GlobalKey<AppTextFieldState> textFieldKey =
      GlobalKey(debugLabel: "_UTF8EncoderViewState");
  late String text = "";
  void onChange(String v) {
    text = v;
    final decode = MethodUtils.nullOnException(() =>
        BytesUtils.tryToHexString(StringUtils.tryEncode(v), prefix: "0x"));
    if (decode != inHex) {
      inHex = decode;
      updateState();
    }
  }

  String? validator(String? v) {
    return null;
  }

  void onPaste(String v) {
    textFieldKey.currentState?.updateText(v);
  }

  void onPressed() {
    if (inHex == null) return;
    if (context.mounted) {
      context.pop(inHex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("utf8_encoder".tr, style: context.textTheme.titleMedium),
        Text("utf8_encoder_desc".tr),
        WidgetConstant.height20,
        AppTextField(
          label: "string".tr,
          initialValue: text,
          validator: validator,
          suffixIcon: PasteTextIcon(onPaste: onPaste, isSensitive: false),
          onChanged: onChange,
          key: textFieldKey,
        ),
        APPAnimatedSize(
            isActive: inHex != null,
            onActive: (context) => ContainerWithBorder(
                  child: CopyableTextWidget(
                      text: inHex!, color: context.onPrimaryContainer),
                ),
            onDeactive: (context) => WidgetConstant.sizedBox),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FixedElevatedButton(
                padding: WidgetConstant.paddingVertical40,
                onPressed: onPressed,
                child: Text('setup'.tr))
          ],
        )
      ],
    );
  }
}
