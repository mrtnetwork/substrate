import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:substrate/future/widgets/widgets/constraint.dart';
import 'package:substrate/app/types/global.dart';
import 'package:flutter/material.dart';

SnackBar createSnackAlert(
    {required String message,
    required DynamicVoid onTap,
    required ThemeData theme}) {
  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    actionOverflowThreshold: 0,
    elevation: 0,
    content: GestureDetector(
      onTap: onTap,
      child: Center(
        child: ConstraintsBoxView(
          maxWidth: 350,
          child: Card(
            elevation: 3,
            child: Container(
              padding: WidgetConstant.padding10,
              decoration: BoxDecoration(
                  color: theme.colorScheme.inverseSurface,
                  borderRadius: WidgetConstant.border8),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      message,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onInverseSurface),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return snackBar;
}
