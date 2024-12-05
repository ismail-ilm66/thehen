import 'package:flutter/material.dart';

class HelperFunctions {
  static Color convertColor(String colorString) {
    try {
      // Check for named colors like "Colors.red"
      if (colorString.startsWith("Colors.")) {
        return Colors.primaries.firstWhere(
          (color) => color.toString().contains(colorString.split(".")[1]),
          orElse: () => const MaterialColor(0xFFFFFFFF, {}),
        );
      }

      if (colorString.startsWith("#")) {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
    } catch (e) {
      print("Error converting color: $e");
    }

    return Colors.white;
  }

  static Alignment convertAlignment(String alignmentString) {
    switch (alignmentString) {
      case "Alignment.topLeft":
        return Alignment.topLeft;
      case "Alignment.bottomRight":
        return Alignment.bottomRight;
      case "Alignment.center":
        return Alignment.center;
      default:
        return Alignment.center;
    }
  }
}
