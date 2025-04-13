import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:math' as math;

Future<Color> typeColorGetter(String imageUrl) async {
  PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
    Image.network(imageUrl).image,
  );
  return palette.dominantColor!.color;
}

Color darkenColor(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

checkDeviceOrientation() {
  if (Get.width > Get.height) {
    Get.printInfo(info: "device is horizontal");
  }

  if (Get.width < Get.height) {
    Get.printInfo(info: "device is vertical");
  }
}

double fullRotation = 360 / (2 * math.pi);
