import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:flutter/material.dart';
import 'constant.dart';
import 'constraint.dart';

class DialogView extends StatelessWidget {
  const DialogView(
      {this.widget,
      this.title,
      this.titleWidget,
      this.content = const [],
      this.child,
      super.key});
  final Widget? widget;
  final Widget? child;
  final String? title;
  final Widget? titleWidget;
  final List<Widget> content;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstraintsBoxView(
        alignment: Alignment.center,
        maxWidth: APPConst.dialogWidth,
        padding: WidgetConstant.padding20,
        child: ClipRRect(
          borderRadius: WidgetConstant.border25,
          child: Material(
            color: context.colors.surface,
            child: child ??
                CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      title: titleWidget ?? Text(title ?? ""),
                      leading: WidgetConstant.sizedBox,
                      leadingWidth: 0,
                      pinned: true,
                      actions: [...content, const CloseButton()],
                    ),
                    SliverToBoxAdapter(
                      child: ConstraintsBoxView(
                        padding: WidgetConstant.padding20,
                        child: widget ?? WidgetConstant.sizedBox,
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
