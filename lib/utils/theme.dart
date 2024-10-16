import 'package:flutter/material.dart';

class CustomTheme {
  static const Color red = Color(0xFFD90429);
  static const Color redSecondary = Color(0xFFBE0D2C);

  static const Color yellow = Color(0xFFFCA311);
  static const Color yellowSecondary = Color(0xFFE7950F);

  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteSecondary = Color(0xFFEDF2F4);

  static const Color black = Color(0XFF000000);
  static const Color blackSecondary = Color(0XFF090909);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: red,
        onPrimary: white,
        inversePrimary: black,
      ),
    );
  }
}
