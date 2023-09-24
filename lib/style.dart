import 'package:flutter/material.dart';

class Style {
  static Color textColorWhite = Colors.white;
  static Color backGroundColor = const Color.fromARGB(232, 20, 138, 192);
  static Color backGroundColorAppBar = const Color.fromARGB(255, 6, 56, 102);
  static Color buttonColor = const Color.fromARGB(255, 184, 180, 173);
  static Color buttonTextColorRed = Colors.red;
  static Color textColorDarkBlue = const Color.fromARGB(255, 6, 56, 102);
  static Color warningBackGroundColor = Colors.red.shade400;
  static double appBarHeight = 30.0;
  static Color lightButtonBackgroundColor =
      const Color.fromARGB(255, 41, 101, 170);
  static Color activeServiceButtonColor = Colors.red;
  static Color notActiveServiceButtonColor = Colors.grey;

  static InputDecoration inputTextDecoration(hintText) {
    return InputDecoration(
        hintText: hintText,
        fillColor: const Color.fromARGB(116, 193, 193, 191),
        filled: true);
  }
 
}
