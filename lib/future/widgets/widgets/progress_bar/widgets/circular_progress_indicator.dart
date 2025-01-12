import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/conditional.dart';
import 'package:flutter/material.dart';

class APPCircularProgressIndicator extends StatelessWidget {
  final double progressWidth;
  final bool enable;
  final WidgetContext? onDeactive;
  final Color? color;
  final Color? backgroundColor;
  const APPCircularProgressIndicator({
    super.key,
    this.onDeactive,
    this.enable = true,
    this.color,
    this.backgroundColor,
    this.progressWidth = APPConst.iconSize,
  });
  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
        onActive: (context) {
          return SizedBox(
            width: progressWidth,
            height: progressWidth,
            child: CircularProgressIndicator(
                color: color, backgroundColor: backgroundColor),
          );
        },
        onDeactive: onDeactive,
        enable: enable);
  }
}
