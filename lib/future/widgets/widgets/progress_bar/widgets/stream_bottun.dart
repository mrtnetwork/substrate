import 'dart:async';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/conditional.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/measure.dart';
import 'package:flutter/material.dart';

enum StreamWidgetStatus {
  idle,
  success,
  error,
  progress,
  hide;

  bool get inProgress => this == StreamWidgetStatus.progress;
}

typedef STREAMWIDGETICON = Widget? Function(
    BuildContext context, StreamWidgetStatus status);

class StreamWidget extends StatefulWidget {
  const StreamWidget({
    GlobalKey<StreamWidgetState>? key,
    required this.buttonWidget,
    this.padding = EdgeInsets.zero,
    this.initialStatus = StreamWidgetStatus.idle,
    this.backToIdle,
    this.hideAfterError = false,
    this.hideAfterSuccsess = false,
    this.fixedSize = true,
    this.color,
  }) : super(key: key);
  final StreamWidgetStatus initialStatus;
  final EdgeInsets padding;
  final Duration? backToIdle;
  final STREAMWIDGETICON buttonWidget;
  final bool hideAfterError;
  final bool hideAfterSuccsess;
  final bool fixedSize;
  final Color? color;

  @override
  State<StreamWidget> createState() => StreamWidgetState();
}

class StreamWidgetState extends State<StreamWidget>
    with SafeState<StreamWidget> {
  late StreamWidgetStatus _status = widget.initialStatus;
  @override
  void initState() {
    super.initState();
  }

  void _listen(StreamWidgetStatus status) async {
    if (status == StreamWidgetStatus.progress ||
        status == StreamWidgetStatus.idle ||
        status == StreamWidgetStatus.hide) {
      return;
    }
    if (widget.backToIdle == null) return;
    await Future.delayed(widget.backToIdle ?? Duration.zero);
    if (widget.hideAfterError && status == StreamWidgetStatus.error) {
      updateStream(StreamWidgetStatus.hide);
    } else if (widget.hideAfterSuccsess &&
        status == StreamWidgetStatus.success) {
      updateStream(StreamWidgetStatus.hide);
    } else {
      updateStream(StreamWidgetStatus.idle);
    }
  }

  void updateStream(StreamWidgetStatus status) {
    if (!mounted) return;
    _status = status;
    _listen(status);
    setState(() {});
  }

  bool get isProgress => _status == StreamWidgetStatus.progress;
  Size? size;
  void onChangeSize(Size widgetSize) {
    if (!widget.fixedSize) return;
    if (size != widgetSize && _status == StreamWidgetStatus.idle) {
      size = widgetSize;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: AnimatedSwitcher(
        duration: APPConst.animationDuraion,
        child: MeasureSize(
          onChange: onChangeSize,
          key: ValueKey(_status),
          child: SizedBox.fromSize(
              size: size,
              child: widget.buttonWidget(context, _status) ??
                  _DefaultButtonIcon(_status, color: widget.color)),
        ),
      ),
    );
  }
}

class _DefaultButtonIcon extends StatelessWidget {
  const _DefaultButtonIcon(this.status, {this.color});
  final StreamWidgetStatus status;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ConditionalWidgets<StreamWidgetStatus>(enable: status, widgets: {
      StreamWidgetStatus.hide: (context) => WidgetConstant.sizedBox,
      StreamWidgetStatus.idle: (context) => WidgetConstant.sizedBox,
      StreamWidgetStatus.success: (context) => Icon(Icons.check_circle,
          color: color ?? Colors.green, size: APPConst.double40),
      StreamWidgetStatus.error: (context) => Icon(Icons.error,
          color: context.colors.error, size: APPConst.double40),
      StreamWidgetStatus.progress: (context) =>
          CircularProgressIndicator(color: color)
    });
  }
}
