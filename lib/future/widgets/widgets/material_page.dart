import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:flutter/material.dart';

class MaterialPageView extends StatelessWidget {
  const MaterialPageView({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.primary,
      child: SafeArea(
          child: Container(color: context.colors.surface, child: child)),
    );
  }
}

class ScaffoldPageView extends StatelessWidget {
  const ScaffoldPageView(
      {required this.child,
      super.key,
      this.appBar,
      this.scaffoldKey,
      this.bottomNavigationBar,
      this.resizeToAvoidBottomInset = true});
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Key? scaffoldKey;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return MaterialPageView(
      child: Scaffold(
          appBar: appBar,
          key: scaffoldKey,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: child,
          bottomNavigationBar: bottomNavigationBar),
    );
  }
}
