import 'dart:async';

import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animation/animated_switcher.dart';

enum _CopyTextStatus {
  idlle,
  pending,
  success,
  error;

  bool get isIdle => this == idlle;
}

mixin _CopyTextState<T extends StatefulWidget> on SafeState<T> {
  String get dataToCopy;
  String? get message;
  bool get isSensitive;
  _CopyTextStatus status = _CopyTextStatus.idlle;
  void onTap(BuildContext context) async {
    if (!status.isIdle) return;
    status = _CopyTextStatus.pending;
    updateState();
    await Clipboard.setData(ClipboardData(text: dataToCopy));
    status = _CopyTextStatus.success;
    // ignore: use_build_context_synchronously
    context.showAlert(message ?? "copied_to_clipboard".tr);
    await Future.delayed(APPConst.oneSecoundDuration);
    status = _CopyTextStatus.idlle;
    updateState();
    if (!isSensitive) return;
    _resetClipoard(dataToCopy);
  }

  static void _resetClipoard(String txt) {
    MethodUtils.after(() async {
      final data = await Clipboard.getData('text/plain');
      if (data?.text != txt) return;
      Clipboard.setData(const ClipboardData(text: ''));
    }, duration: APPConst.tenSecoundDuration);
  }
}

class CopyableTextWidget extends StatefulWidget {
  const CopyableTextWidget(
      {super.key,
      required this.text,
      this.maxLines = 1,
      this.size,
      this.messaage,
      this.color,
      this.widget,
      this.isSensitive = false});

  final String text;
  final double? size;
  final String? messaage;
  final Color? color;
  final Widget? widget;
  final bool isSensitive;
  final int? maxLines;

  @override
  State<CopyableTextWidget> createState() => CopyableTextWidgetState();
}

class CopyableTextWidgetState extends State<CopyableTextWidget>
    with SafeState, _CopyTextState {
  @override
  String get dataToCopy => widget.text;

  @override
  bool get isSensitive => widget.isSensitive;

  @override
  String? get message => widget.messaage;

  @override
  Widget build(BuildContext context) {
    final icon = IconButton(
      onPressed: () => onTap(context),
      icon: APPAnimatedSwitcher(enable: status, widgets: {
        _CopyTextStatus.idlle: (context) =>
            Icon(Icons.copy, size: widget.size, color: widget.color),
        _CopyTextStatus.pending: (context) => SizedBox(
            width: widget.size ?? APPConst.iconSize,
            height: widget.size ?? APPConst.iconSize,
            child: CircularProgressIndicator(color: widget.color)),
        _CopyTextStatus.success: (context) =>
            Icon(Icons.check_circle, size: widget.size, color: widget.color),
        _CopyTextStatus.error: (context) =>
            Icon(Icons.error, size: widget.size, color: context.colors.error)
      }),
    );
    return InkWell(
      onTap: () => onTap(context),
      customBorder:
          RoundedRectangleBorder(borderRadius: WidgetConstant.border8),
      child: Row(
        children: [
          Expanded(
              child: widget.widget ??
                  Text(
                    widget.text,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: widget.color),
                    maxLines: widget.maxLines,
                    overflow:
                        widget.maxLines == null ? null : TextOverflow.ellipsis,
                  )),
          WidgetConstant.width8,
          icon
        ],
      ),
    );
  }
}

class CopyableTextIcon extends StatefulWidget {
  const CopyableTextIcon(
      {super.key,
      required this.text,
      this.size,
      this.messaage,
      this.color,
      this.isSensitive = false});

  final String text;
  final double? size;
  final String? messaage;
  final Color? color;
  final bool isSensitive;

  @override
  State<CopyableTextIcon> createState() => CopyableTextIconState();
}

class CopyableTextIconState extends State<CopyableTextIcon>
    with SafeState, _CopyTextState {
  @override
  String get dataToCopy => widget.text;

  @override
  bool get isSensitive => widget.isSensitive;

  @override
  String? get message => widget.messaage;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onTap(context),
      icon: APPAnimatedSwitcher(enable: status, widgets: {
        _CopyTextStatus.idlle: (context) =>
            Icon(Icons.copy, size: widget.size, color: widget.color),
        _CopyTextStatus.pending: (context) => SizedBox(
            width: widget.size ?? APPConst.iconSize,
            height: widget.size ?? APPConst.iconSize,
            child: CircularProgressIndicator(color: widget.color)),
        _CopyTextStatus.success: (context) =>
            Icon(Icons.check_circle, size: widget.size, color: widget.color),
        _CopyTextStatus.error: (context) =>
            Icon(Icons.error, size: widget.size, color: context.colors.error)
      }),
    );
  }
}
