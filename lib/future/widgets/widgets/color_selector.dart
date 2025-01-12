import 'package:substrate/app/types/global.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets/constant.dart';
import 'package:flutter/material.dart';

typedef OnSelectColor = void Function(Color?);

class ColorSelectorIconView extends StatelessWidget {
  const ColorSelectorIconView(
      {required this.onSelectColor, required this.color, super.key});
  final OnSelectColor onSelectColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context
              .openSliverDialog<Color>(
                  (ctx) => const ColorSelectorModal(), "primary_color".tr)
              .then(onSelectColor);
        },
        icon: Icon(Icons.color_lens, color: color));
  }
}

class BrightnessToggleIcon extends StatelessWidget {
  const BrightnessToggleIcon({
    required this.onToggleBrightness,
    required this.brightness,
    required this.color,
    super.key,
  });
  final DynamicVoid onToggleBrightness;
  final Brightness brightness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onToggleBrightness,
        icon: brightness == Brightness.dark
            ? Icon(
                Icons.dark_mode,
                color: color,
              )
            : Icon(Icons.light_mode, color: color));
  }
}

class ColorSelectorModal extends StatelessWidget {
  const ColorSelectorModal({super.key});
  static const List<Color> defaultColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("select_color_from_blow".tr),
        WidgetConstant.height20,
        Wrap(
          children: List.generate(defaultColors.length, (index) {
            return InkWell(
              onTap: () {
                context.pop(defaultColors[index]);
              },
              child: Padding(
                padding: WidgetConstant.padding10,
                child: Icon(
                  Icons.color_lens,
                  color: defaultColors[index],
                  size: APPConst.double40,
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
