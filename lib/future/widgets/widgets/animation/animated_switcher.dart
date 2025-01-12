import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/typdef/typedef.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/sliver/widgets/animated_switcher.dart';
import 'package:flutter/material.dart';

class APPAnimatedSwitcher<T> extends StatelessWidget {
  const APPAnimatedSwitcher(
      {required this.enable,
      required this.widgets,
      this.height,
      this.width,
      this.transitionBuilder,
      this.duration = APPConst.animationDuraion,
      super.key});
  final double? height;
  final double? width;
  final T? enable;
  final Map<T?, WidgetContextNullable> widgets;
  final Duration duration;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder:
          transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
      child: _Wrap(
        widgets[enable]?.call(context) ?? WidgetConstant.sizedBox,
        key: ValueKey(enable),
        height: height,
        width: width,
      ),
    );
  }
}

class APPSliverAnimatedSwitcher<T> extends StatelessWidget {
  const APPSliverAnimatedSwitcher(
      {required this.enable,
      required this.widgets,
      this.defaultWidget,
      this.duration = APPConst.animationDuraion,
      super.key});
  final WidgetContext? defaultWidget;
  final T? enable;
  final Map<T?, WidgetContext> widgets;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedSwitcher(
      duration: duration,
      child: _WrapSliver(
          widgets[enable]?.call(context) ??
              defaultWidget?.call(context) ??
              const SliverToBoxAdapter(),
          key: ValueKey<T?>(enable)),
    );
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap(this.widget, {this.height, this.width, super.key});
  final Widget widget;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width, child: widget);
  }
}

class _WrapSliver extends StatelessWidget {
  const _WrapSliver(this.sliver, {super.key});
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return sliver;
  }
}
