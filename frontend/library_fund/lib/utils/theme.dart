import "package:flutter/material.dart";

import 'constants.dart';

ThemeData basicTheme() => ThemeData(
      brightness: Brightness.light,
      primaryColor: appPrimaryColor,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: appFontFamily,
          fontSize: appMediumTextSize,
          fontWeight: FontWeight.w800,
          color: appSecondaryColor,
        ),
        headlineMedium: TextStyle(
            fontFamily: appFontFamily,
            fontSize: appMediumTextSize,
            fontWeight: FontWeight.w500,
            color: appSecondaryColor),
        bodyLarge: TextStyle(
          fontFamily: appFontFamily,
          fontSize: appBodyTextSize,
          color: Color.fromARGB(255, 58, 55, 55),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        height: 80,
        buttonColor: appPrimaryColor,
        textTheme: ButtonTextTheme.accent,
      ),
      colorScheme: ColorScheme.fromSeed(
          seedColor: appPrimaryColor,
          primary: appPrimaryColor,
          secondary: appSecondaryColor,
          background: appBackgroundColor),
    );
