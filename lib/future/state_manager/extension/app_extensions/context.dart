import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/theme/theme.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'snackbar.dart';

extension CustomColorsSchame on ColorScheme {
  Color get disable => onSurface.wOpacity(0.38);
  Color get orange => Colors.orange;
  Color get green => Colors.green;
  Color get transparent => Colors.transparent;
}

extension QuickColor on Color {
  Color wOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }
}

extension QuickContextAccsess on BuildContext {
  T watch<T extends StateController>(String stateId) {
    return StateRepository.stateOf(this, stateId)!;
  }

  T watchOrCreate<T extends StateController>(
      {required String stateId, required T Function() controller}) {
    return StateRepository.stateOfCreate(this, stateId, controller)!;
  }

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  Color get onPrimaryContainer => colors.onPrimaryContainer;
  Color get primaryContainer => colors.primaryContainer;
  TextTheme get onPrimaryTextTheme => ThemeController.onPrimary;
  TextTheme get primaryTextTheme => ThemeController.primary;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  bool get hasFocus => FocusScope.of(this).hasFocus;
  bool get hasParentFocus => FocusScope.of(this).parent?.hasFocus ?? false;
  void mybePop() {
    if (mounted) Navigator.maybeOf(this);
  }

  void clearFocus() {
    if (mounted) {
      FocusScope.of(this).unfocus();
    }
  }

  Future<T?> to<T>(String path, {dynamic argruments}) async {
    if (mounted) {
      final push = await Navigator.pushNamed(this, path, arguments: argruments);
      return (push as T?);
    }
    return null;
  }

  Future<T?> mybeTo<T>(String? path, {dynamic argruments}) async {
    if (path != null && mounted) {
      final push = await Navigator.pushNamed(this, path, arguments: argruments);
      return (push as T?);
    }
    return null;
  }

  Future<T?> toPage<T>(Widget page, {dynamic argruments}) async {
    if (mounted) {
      final push = await Navigator.push(
          this, MaterialPageRoute(builder: (context) => page));
      return (push as T?);
    }
    return null;
  }

  bool toSync(String path, {dynamic argruments}) {
    if (!mounted) return false;
    Navigator.pushNamed(this, path, arguments: argruments);
    return true;
  }

  Future<T?> offTo<T>(String path, {dynamic argruments}) async {
    if (mounted) {
      final push =
          Navigator.popAndPushNamed<T, T>(this, path, arguments: argruments);
      return push;
    }
    return null;
  }

  void showAlert(String message) {
    if (mounted) {
      final sc = StateRepository.messengerKey(this);
      SnackBar snackBar;
      snackBar = createSnackAlert(
        message: message,
        theme: theme,
        onTap: () {
          sc.currentState?.clearSnackBars();
        },
      );
      sc.currentState?.showSnackBar(snackBar);
    }
  }

  Future<T?> openSliverBottomSheet<T>(String label,
      {double minExtent = 0.7,
      double maxExtend = 1,
      Widget? child,
      double? initialExtend,
      BodyBuilder? bodyBuilder,
      List<Widget> Function(BuildContext context)? appbarActions,
      List<Widget> slivers = const [],
      bool centerContent = true}) async {
    if (minExtent > maxExtend) {
      minExtent = maxExtend;
    }
    if (!mounted) return null;
    return await showModalBottomSheet<T>(
      context: this,
      constraints: const BoxConstraints(maxWidth: 900),
      builder: (context) => AppBottomSheet(
        label: label,
        body: bodyBuilder,
        actions: appbarActions?.call(context) ?? [],
        minExtent: minExtent,
        maxExtend: maxExtend,
        centerContent: centerContent,
        slivers: slivers,
        initiaalExtend: initialExtend,
        child: child,
      ),
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Future<T?> openSliverDialog<T>(WidgetContext widget, String label,
      {List<Widget> Function(BuildContext)? content}) async {
    return await showAdaptiveDialog(
      context: this,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context) {
        return DialogView(
          title: label,
          content: content?.call(context) ?? const [],
          widget: widget(context),
        );
      },
    );
  }

  Future<T?> openDialogPage<T>(
    String label, {
    WidgetContext? child,
    List<Widget> Function(BuildContext)? content,
    Widget? fullWidget,
  }) async {
    return await showAdaptiveDialog(
      context: this,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context) {
        return fullWidget ??
            DialogView(
                title: label,
                content: content?.call(context) ?? const [],
                child: child?.call(context) ?? WidgetConstant.sizedBox);
      },
    );
  }

  void pop<T>([T? result]) {
    if (mounted) {
      Navigator.of(this).pop(result);
    }
  }

  T? getNullArgruments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args == null) return null;
    if (args.runtimeType != T) {
      return null;
    }
    return args as T?;
  }

  T getArgruments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args == null) {
      throw StateError("argruments not found");
    }

    return args as T;
  }

  dynamic getDynamicArgs() {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args == null) {
      throw StateError("argruments not found");
    }

    return args;
  }

  BuildContext? get scaffoldContext =>
      StateRepository.scaffoldKey(this).currentContext;

  GlobalKey<ScaffoldState> get scaffoldKey => StateRepository.scaffoldKey(this);

  GlobalKey<NavigatorState> get navigatorKey =>
      StateRepository.navigatorKey(this);
  ModalRoute? route() {
    return ModalRoute.of(this);
  }

  String? path() {
    String? currentPath;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }
}
