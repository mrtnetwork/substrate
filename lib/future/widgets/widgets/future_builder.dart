import 'package:substrate/future/state_manager/typdef/typedef.dart';
import 'package:substrate/future/widgets/widgets/animation/animated_switcher.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class APPFutureBuilder<T> extends StatelessWidget {
  const APPFutureBuilder(
      {this.onData,
      this.onError,
      this.onProgress,
      required this.future,
      super.key});
  final WidgetDataContext<T>? onData;
  final WidgetErrContext? onError;
  final WidgetContext? onProgress;
  final Future<T> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        return APPAnimatedSwitcher(enable: snapshot.connectionState, widgets: {
          ConnectionState.waiting: (context) =>
              onProgress?.call(context) ?? const APPCircularProgressIndicator(),
          ConnectionState.done: (context) {
            return switch (snapshot.hasData) {
              false => onError?.call(context, snapshot.error!),
              true => onData?.call(context, snapshot.data as T)
            };
          }
        });
      },
    );
  }
}

class APPStreamBuilder<T> extends StatelessWidget {
  const APPStreamBuilder(
      {required this.stream,
      this.onData,
      this.onError,
      this.onProgress,
      super.key});
  final Stream<T> stream;
  final WidgetDataContext<T>? onData;
  final WidgetErrContext? onError;
  final WidgetContext? onProgress;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return APPAnimatedSwitcher(enable: snapshot.connectionState, widgets: {
          ConnectionState.waiting: (context) =>
              onProgress?.call(context) ?? const APPCircularProgressIndicator(),
          ConnectionState.active: (context) {
            return switch (snapshot.hasData) {
              false => onError?.call(context, snapshot.error!),
              true => onData?.call(context, snapshot.data as T)
            };
          },
          ConnectionState.done: (context) {
            return switch (snapshot.hasData) {
              false => onError?.call(context, snapshot.error!),
              true => onData?.call(context, snapshot.data as T)
            };
          }
        });
      },
    );
  }
}
