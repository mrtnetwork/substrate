import 'package:substrate/app/tools/func.dart';
import 'package:substrate/app/tools/string_utils.dart';
import 'package:substrate/app/types/global.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/paste_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

class AppTextField extends StatefulWidget {
  const AppTextField(
      {super.key,
      this.minlines,
      this.maxLines,
      this.label,
      this.onChanged,
      this.hint,
      this.error,
      this.validator,
      this.inputFormatters,
      this.suffix,
      this.helperText,
      this.keyboardType,
      this.textDirection,
      this.padding = WidgetConstant.paddingVertical8,
      this.obscureText = false,
      this.suffixIcon,
      this.prefix,
      this.prefixIcon,
      this.textInputAction,
      this.focusNode,
      this.nextFocus,
      this.disableContextMenu = false,
      this.filled = true,
      this.initialValue,
      this.style,
      this.textAlign = TextAlign.start,
      this.readOnly = false,
      this.pasteIcon = false,
      this.isSensitive,
      this.helperStyle,
      this.onSubmitField,
      this.autovalidateMode = AutovalidateMode.onUserInteraction});
  final String? label;
  final String? hint;
  final String? error;
  final StringVoid? onChanged;
  final StringVoid? onSubmitField;
  final NullStringString? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final EdgeInsets padding;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool disableContextMenu;
  final int? minlines;
  final int? maxLines;
  final bool filled;
  final String? initialValue;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool readOnly;
  final bool pasteIcon;
  final bool? isSensitive;
  final TextStyle? helperStyle;
  final AutovalidateMode autovalidateMode;
  @override
  State<AppTextField> createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField>
    with SafeState<AppTextField> {
  late TextDirection? direction = widget.textDirection;
  final TextEditingController controller = TextEditingController();
  late bool obscureText = widget.obscureText;
  void listener() {
    widget.onChanged?.call(controller.text);
  }

  void onChaangeObscureText() {
    obscureText = !obscureText;
    setState(() {});
  }

  void onChange(String value) {
    if (!mounted) return;
    if (widget.textDirection != null) return;
    if (value.trim().isEmpty) {
      if (direction != null) {
        direction = null;
        setState(() {});
      }
    } else if (StrUtils.startsWithRtl(value)) {
      if (direction != TextDirection.rtl) {
        direction = TextDirection.rtl;
        setState(() {});
      }
    } else {
      if (direction != TextDirection.ltr) {
        direction = TextDirection.ltr;
        setState(() {});
      }
    }
  }

  void onSubmitField(String v) {
    if (mounted) {
      widget.nextFocus?.requestFocus();
      widget.onSubmitField?.call(v);
    }
  }

  void updateText(String text) {
    if (text == controller.text) return;
    if (mounted) {
      controller.text = text;
    }
  }

  void clear() {
    if (mounted) {
      controller.clear();
    }
  }

  String getValue() => controller.text;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    MethodUtils.after(() async => updateText(widget.initialValue ?? ""));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null &&
        oldWidget.initialValue != widget.initialValue) {
      MethodUtils.after(() async => updateText(widget.initialValue!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        textAlign: widget.textAlign,
        controller: controller,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        autofillHints: const [],
        onChanged: onChange,
        textDirection: direction,
        autovalidateMode: widget.autovalidateMode,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        obscureText: obscureText,
        style: widget.style,
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: onSubmitField,
        minLines: widget.minlines,
        selectionControls: MaterialTextSelectionControls(),
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        contextMenuBuilder: widget.disableContextMenu
            ? null
            : (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.editableText(
                    editableTextState: editableTextState);
              },
        decoration: InputDecoration(
            filled: widget.filled,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
            helperStyle: widget.helperStyle,
            helperMaxLines: 2,
            errorMaxLines: 2,
            helperText: widget.helperText,
            labelText: widget.label,
            border: OutlineInputBorder(
                borderRadius: WidgetConstant.border8,
                borderSide: BorderSide.none),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (widget.obscureText)
                //   ObscureIcon(show: obscureText, onTap: onChaangeObscureText),
                if (widget.pasteIcon)
                  PasteTextIcon(
                      onPaste: updateText,
                      isSensitive: widget.isSensitive ?? false),
                if (widget.suffixIcon != null) widget.suffixIcon!,
              ],
            ),
            hintText: widget.hint,
            errorText: widget.error),
      ),
    );
  }
}
