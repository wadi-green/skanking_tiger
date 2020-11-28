import 'package:flutter/material.dart';

import 'colors.dart';

final primaryTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: MainColors.primary,
  primarySwatch: MainColors.primarySwatch,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: MainColors.white,
  appBarTheme: const AppBarTheme(
    color: MainColors.white,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: MainColors.darkGrey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(MainColors.primary),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 8,
      )),
      textStyle: TextButton.styleFrom(primary: Colors.white).textStyle,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(MainColors.btnBlack),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);
