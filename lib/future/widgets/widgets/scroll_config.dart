import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  AppScrollBehavior();
  late final bool isWindowsOrWeb =
      kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  @override
  late final Set<PointerDeviceKind> dragDevices = isWindowsOrWeb
      ? {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }
      : super.dragDevices;
}
