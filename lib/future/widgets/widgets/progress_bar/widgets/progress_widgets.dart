import 'package:substrate/app/types/global.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/button.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/constraint.dart';
import 'package:substrate/future/widgets/widgets/container.dart';
import 'package:substrate/future/widgets/widgets/copyable_text.dart';
import 'package:substrate/future/widgets/widgets/large_text.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:flutter/material.dart';

Widget get initializeProgressWidget =>
    ProgressWithTextView(text: "initializing_requirements".tr);

class ProgressWithTextView extends StatelessWidget {
  const ProgressWithTextView(
      {super.key,
      required this.text,
      this.icon,
      this.style,
      this.bottomWidget});
  final String text;
  final Widget? icon;
  final TextStyle? style;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return _ProgressWithTextView(
      text: Column(
        children: [
          LargeTextView([text],
              maxLine: 3, textAligen: TextAlign.center, style: style),
          if (bottomWidget != null) bottomWidget!
        ],
      ),
      icon: icon,
    );
  }
}

class ErrorWithTextView extends StatelessWidget {
  const ErrorWithTextView(
      {super.key, required this.text, this.progressKey, this.button});
  final String text;
  final GlobalKey<PageProgressBaseState>? progressKey;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return _ProgressWithTextView(
        text: Column(
          children: [
            ConstraintsBoxView(
              maxHeight: 120,
              child: Container(
                padding: WidgetConstant.padding10,
                decoration: BoxDecoration(
                    borderRadius: WidgetConstant.border8,
                    color: context.colors.errorContainer),
                child: SingleChildScrollView(
                  child: SelectableText(
                    text,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: context.colors.onErrorContainer),
                  ),
                ),
              ),
            ),
            if (progressKey != null) ...[
              WidgetConstant.height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                      onPressed: () {
                        progressKey?.backToIdle();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: Text("back_to_the_page".tr))
                ],
              )
            ],
            if (button != null) ...[
              WidgetConstant.height20,
              button!,
            ],
          ],
        ),
        icon: WidgetConstant.errorIconLarge);
  }
}

class SuccessWithTextView extends StatelessWidget {
  const SuccessWithTextView({super.key, required this.text, this.icon});
  final String text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return _ProgressWithTextView(
        text: Text(text, textAlign: TextAlign.center),
        icon: icon != null
            ? Icon(icon, size: APPConst.double80)
            : WidgetConstant.checkCircleLarge);
  }
}

class SuccessCopyableTextView extends StatelessWidget {
  const SuccessCopyableTextView({super.key, required this.text, this.icon});
  final String text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return _ProgressWithTextView(
        text: ContainerWithBorder(
            child: CopyableTextWidget(
                text: text,
                widget: Text(text,
                    textAlign: TextAlign.center,
                    style: context.onPrimaryTextTheme.bodyMedium,
                    maxLines: 2),
                color: context.onPrimaryContainer)),
        icon: icon != null
            ? Icon(icon, size: APPConst.double80)
            : WidgetConstant.checkCircleLarge);
  }
}

class SuccessWithButtonView extends StatelessWidget {
  const SuccessWithButtonView(
      {super.key,
      this.text,
      required this.buttonText,
      this.buttonWidget,
      required this.onPressed})
      : assert(text != null || buttonWidget != null,
            "use text or buttonWidget for child");
  final String? text;
  final String buttonText;
  final Widget? buttonWidget;
  final DynamicVoid onPressed;

  @override
  Widget build(BuildContext context) {
    return _ProgressWithTextView(
        text: Column(
          children: [
            buttonWidget ?? Text(text!, textAlign: TextAlign.center),
            WidgetConstant.height8,
            FilledButton(onPressed: onPressed, child: Text(buttonText))
          ],
        ),
        icon: WidgetConstant.checkCircleLarge);
  }
}

class _ProgressWithTextView extends StatelessWidget {
  const _ProgressWithTextView({required this.text, this.icon});
  final Widget text;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? const CircularProgressIndicator(),
        WidgetConstant.height8,
        text,
      ],
    );
  }
}

enum ProgressMultipleTextViewStatus { error, success }

class ProgressButtonWidget extends StatelessWidget {
  const ProgressButtonWidget(
      {required this.label, required this.onTap, super.key});
  final DynamicVoid onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      FixedElevatedButton(
          padding: WidgetConstant.paddingVertical20,
          onPressed: onTap,
          child: Text(label)),
    ]);
  }
}

class ProgressMultipleTextViewObject {
  final ProgressMultipleTextViewStatus status;
  final String text;
  final bool enableCopy;
  final String? openUrl;
  bool get isSuccess => status == ProgressMultipleTextViewStatus.success;
  const ProgressMultipleTextViewObject(
      {required this.status,
      required this.text,
      required this.enableCopy,
      this.openUrl});
  factory ProgressMultipleTextViewObject.success({
    required String message,
    String? openUrl,
    bool enableCopy = true,
  }) {
    return ProgressMultipleTextViewObject(
        status: ProgressMultipleTextViewStatus.success,
        text: message,
        enableCopy: enableCopy,
        openUrl: openUrl);
  }
  factory ProgressMultipleTextViewObject.error(
      {required String message, bool enableCopy = false}) {
    return ProgressMultipleTextViewObject(
        status: ProgressMultipleTextViewStatus.error,
        text: message,
        enableCopy: enableCopy);
  }
}
