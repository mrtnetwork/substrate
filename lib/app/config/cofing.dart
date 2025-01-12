import 'package:flutter/material.dart';

class APPConfig {
  static const APPConfig defaultConfig =
      APPConfig(color: Colors.deepOrange, brightness: Brightness.light);
  final Brightness brightness;
  final Color color;
  const APPConfig({required this.color, required this.brightness});
  factory APPConfig.fromJson(Map<String, dynamic> json) {
    return APPConfig(
        color: Color.from(
            alpha: json["alpha"],
            red: json["red"],
            green: json["green"],
            blue: json["blue"]),
        brightness:
            Brightness.values.firstWhere((e) => e.name == json["brightness"]));
  }

  APPConfig copyWith({Color? color, Brightness? brightness}) {
    return APPConfig(
        color: color ?? this.color, brightness: brightness ?? this.brightness);
  }

  Map<String, dynamic> toJson() {
    return {
      "alpha": color.a,
      "red": color.r,
      "green": color.g,
      "blue": color.b,
      "brightness": brightness.name
    };
  }
}
