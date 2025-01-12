import 'package:substrate/future/state_manager/extension/app_extensions/color.dart';
import 'package:flutter/material.dart';

class ThemeController {
  static const List<int> materialSettingCborTag = [100];
  static Color _appColor = Colors.orange;
  static Color get appColor => _appColor;
  static Brightness _appBrightness = Brightness.light;
  static ColorScheme colorScheme =
      ColorScheme.fromSeed(seedColor: _appColor, brightness: _appBrightness);
  static ColorScheme _buildColorSchame() {
    return ColorScheme.fromSeed(
        seedColor: _appColor, brightness: _appBrightness);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final ThemeData theme = ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme: const TextTheme(),
        primaryTextTheme: const TextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            helperMaxLines: 3,
            errorMaxLines: 3,
            helperStyle: TextStyle(color: Colors.green)),
        segmentedButtonTheme: const SegmentedButtonThemeData(
            selectedIcon: Icon(Icons.check_circle)));
    return theme;
  }

  static ThemeData _appTheme = _buildTheme(colorScheme);
  static ThemeData get appTheme => _appTheme;
  static TextTheme _onPrimary = buildOnPrimary(_appTheme);
  static TextTheme get onPrimary => _onPrimary;

  static TextTheme _primary = buildPrimary(_appTheme);
  static TextTheme get primary => _primary;
  static TextTheme buildOnPrimary(ThemeData theme) {
    return theme.textTheme.copyWith(
      bodyMedium: theme.textTheme.bodyMedium
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      bodySmall: theme.textTheme.bodySmall
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      bodyLarge: theme.textTheme.bodyLarge
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      labelMedium: theme.textTheme.labelMedium
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      labelLarge: theme.textTheme.labelLarge
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      labelSmall: theme.textTheme.labelSmall
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      titleMedium: theme.textTheme.titleMedium
          ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
    );
  }

  static TextTheme buildPrimary(ThemeData theme) {
    return theme.textTheme.copyWith(
      bodyMedium: theme.textTheme.bodyMedium
          ?.copyWith(color: theme.colorScheme.primaryContainer),
      bodySmall: theme.textTheme.bodySmall
          ?.copyWith(color: theme.colorScheme.primaryContainer),
      bodyLarge: theme.textTheme.bodyLarge
          ?.copyWith(color: theme.colorScheme.primaryContainer),
      labelMedium: theme.textTheme.labelMedium
          ?.copyWith(color: theme.colorScheme.primaryContainer),
      labelLarge: theme.textTheme.labelLarge
          ?.copyWith(color: theme.colorScheme.primaryContainer),
      labelSmall: theme.textTheme.labelSmall
          ?.copyWith(color: theme.colorScheme.primaryContainer),
      titleMedium: theme.textTheme.titleMedium
          ?.copyWith(color: theme.colorScheme.primaryContainer),
    );
  }

  static Locale locale = const Locale("en");

  static void _rebuildTheme() {
    colorScheme = _buildColorSchame();
    _appTheme = _buildTheme(colorScheme);
    _onPrimary = buildOnPrimary(_appTheme);
    _primary = buildPrimary(_appTheme);
  }

  static void updatePrimary(ThemeData theme) {
    _onPrimary = buildOnPrimary(theme);
    _primary = buildPrimary(theme);
  }

  static void changeBrightness(Brightness brightness) {
    _appBrightness = brightness;
    _rebuildTheme();
  }

  static void toggleBrightness() {
    _appBrightness =
        _appBrightness == Brightness.light ? Brightness.dark : Brightness.light;
    _rebuildTheme();
  }

  static void changeColor(Color color) {
    _appColor = color;
    _rebuildTheme();
  }

  static String get appColorHex => _appColor.toHex();

  static Brightness get appBrightness => _appBrightness;
}
