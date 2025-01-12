import 'package:substrate/future/state_manager/typdef/typedef.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:flutter/material.dart';

class ConditionalWidgets<T> extends StatelessWidget {
  const ConditionalWidgets(
      {required this.enable,
      required this.widgets,
      this.defaultValue,
      super.key});
  final T? enable;
  final Map<T?, WidgetContext> widgets;
  final Widget? defaultValue;

  @override
  Widget build(BuildContext context) {
    return _Wrap(
        widgets[enable]?.call(context) ??
            defaultValue ??
            WidgetConstant.sizedBox,
        key: ValueKey<T?>(enable));
  }
}

class ConditionalWidget extends StatelessWidget {
  const ConditionalWidget(
      {required this.onActive, this.onDeactive, this.enable = true, super.key});
  final WidgetContext onActive;
  final WidgetContext? onDeactive;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return ConditionalWidgets(enable: enable, widgets: {
      true: (context) => onActive(context),
      false: (context) => onDeactive?.call(context) ?? WidgetConstant.sizedBox
    });
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap(this.widget, {super.key});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}
