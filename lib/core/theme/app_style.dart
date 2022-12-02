import 'package:flutter/material.dart';
import 'app_color.dart';

class AppStyle {
  final TextTheme appTextThemeLight = TextTheme(
      // Estilo do corpo do app.
      bodyText1: _textStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyText2: _textStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      subtitle1: _textStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      subtitle2: _textStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      headline1: _textStyle(
        fontSize: 96.0,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
      ),
      headline2: _textStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
      ),
      headline3: _textStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headline4: _textStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      headline5: _textStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.18,
      ),
      headline6: _textStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      caption: _textStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      overline: _textStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
      button: _textStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ));
}

TextStyle _textStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required double letterSpacing,
}) {
  return TextStyle(
//    fontFamily: 'Roboto', // Caso queira adicionar uma fonte diferente
    fontSize: fontSize,
    color: appDarkGreyColor,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
  );
}
