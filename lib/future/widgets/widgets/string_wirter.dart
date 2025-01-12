import 'package:substrate/app/types/global.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'constant.dart';
import 'text_field.dart';

enum StringWirterOptions {
  address(name: "Address", description: "address_to_bytes_desc");

  final String name;
  final String description;
  const StringWirterOptions({required this.name, required this.description});
}

class StringWriterView extends StatefulWidget {
  const StringWriterView(
      {super.key,
      required this.title,
      required this.label,
      required this.buttonText,
      this.customForm,
      this.defaultValue,
      this.minLength,
      this.maxLength,
      this.regExp,
      this.minLines,
      this.maxLines,
      this.options = const []});
  final Widget title;
  final String label;
  final String buttonText;
  final int? minLength;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final RegExp? regExp;
  final String? defaultValue;
  final NullStringString? customForm;
  final List<StringWirterOptions> options;

  @override
  State<StringWriterView> createState() => _StringWriterViewState();
}

class _StringWriterViewState extends State<StringWriterView>
    with SafeState<StringWriterView> {
  final GlobalKey<AppTextFieldState> textFieldKey =
      GlobalKey(debugLabel: "_StringWriterViewState");
  final GlobalKey<FormState> formKey =
      GlobalKey(debugLabel: "_StringWriterViewState_1");
  late String text = widget.defaultValue ?? "";
  void onChange(String v) {
    text = v;
  }

  String? validator(String? v) {
    if (widget.minLength == null &&
        widget.maxLength == null &&
        widget.regExp == null) {
      return null;
    }
    if (widget.regExp != null) {
      if (!widget.regExp!.hasMatch(v!)) {
        return "regular_exception_validate_desc"
            .tr
            .replaceOne(widget.regExp!.pattern);
      }
    }
    final int length = v?.length ?? 0;
    if (length < (widget.minLength ?? 0)) {
      return "character_length_min_validator"
          .tr
          .replaceOne("${widget.minLength ?? 0}");
    }
    if (widget.maxLength != null && length > widget.maxLength!) {
      return "character_length_max_validator"
          .tr
          .replaceOne("${widget.maxLength ?? 0}");
    }
    return null;
  }

  void onPaste(String v) {
    textFieldKey.currentState?.updateText(v);
  }

  void onPressed() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (context.mounted) {
      context.pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title,
          WidgetConstant.height20,
          AppTextField(
            label: widget.label,
            minlines: widget.minLines ?? 3,
            maxLines: widget.maxLines ?? 5,
            initialValue: text,
            validator: widget.customForm ?? validator,
            pasteIcon: true,
            onChanged: onChange,
            key: textFieldKey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FixedElevatedButton(
                  padding: WidgetConstant.paddingVertical40,
                  onPressed: onPressed,
                  child: Text(widget.buttonText))
            ],
          )
        ],
      ),
    );
  }
}
