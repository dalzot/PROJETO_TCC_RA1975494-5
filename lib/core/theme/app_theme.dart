import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_style.dart';

class AppTheme {
  ThemeData appThemeDataLight = ThemeData.light().copyWith(
    primaryColor: appNormalPrimaryColor,
    primaryColorLight: appNormalPrimaryColor,
    // Setando a cor padrão do background das páginas.
    scaffoldBackgroundColor: appBackgroundColor,
    // Setando o estilo de texto padrão
    textTheme: AppStyle().appTextThemeLight,
    // Definindo o theme light
    brightness: Brightness.light,
    // Setando a cor padrão do AppBars
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: appNormalPrimaryColor,
      iconTheme: const IconThemeData(
        color: appWhiteColor,
      ),
      titleTextStyle: AppStyle()
          .appTextThemeLight
          .headline6!
          .copyWith(color: appWhiteColor),
    ),
    // Setando a cor padrão do ElevatedButton
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     backgroundColor: MaterialStateProperty.all(appNormalPrimaryColor),
    //   ),
    // ),

    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(
        appNormalPrimaryColor.withOpacity(0.2),
      ),
      foregroundColor: MaterialStateProperty.all(appNormalPrimaryColor),
    )),
    iconTheme: const IconThemeData(color: appDarkGreyColor),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: appDarkGreyColor),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appNormalPrimaryColor, width: 2)),
      border: OutlineInputBorder(),
    ),
    dividerColor: appExtraLightGreyColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: appNormalPrimaryColor, secondary: appNormalPrimaryColor),
  );
}
