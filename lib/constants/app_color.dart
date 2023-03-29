import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static const primaryColor = MaterialColor(0xFF32AC71, {
    50: Color(0xFFE8F7F2),
    100: Color(0xFFC7ECE7),
    200: Color(0xFFA3E0DB),
    300: Color(0xFF7FD3CF),
    400: Color(0xFF5AC6C3),
    500: Color(0xFF32AC71),
    600: Color(0xFF2D9E66),
    700: Color(0xFF278F5A),
    800: Color(0xFF21804E),
    900: Color(0xFF16703F),
  });

  static const appBarTextColor = Colors.white;
  static const selectedNavIconColor = Colors.pink;

  static const white = Colors.white;
  static const black = Colors.black;
  static const blue = Colors.blue;
  static const grey = Colors.grey;
  static const red = Colors.red;

  static const popupDeleteColor = Colors.red;
  static const popupChangePasswordColor = Colors.blue;
  static const popupEditColor = primaryColor;
}
