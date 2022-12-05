import '../../../core/theme/app_color.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

TextTheme appStyle = Get.textTheme;

// FONT STYLES
// Heading/Titles
final fontStyleH1 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w300,
  fontSize: 96,
);
final fontStyleH2 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w300,
  fontSize: 60,
);
final fontStyleH3 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 48,
);
final fontStyleH4 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 34,
);
final fontStyleH5 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 24,
);
final fontStyleH6 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 20,
);

// Subtitles
final fontStyleSubtitle1 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 16,
);
final fontStyleSubtitle2 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 14,
);
final fontStyleSubtitle3 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  wordSpacing: 0.04,
  fontSize: 12,
);
final fontStyleSubtitle4 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[500],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.01,
  fontSize: 16,
);

final fontStyleSubtitle5 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
  fontSize: 16,
);

final fontStyleSubtitle6 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[500],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.01,
  fontSize: 16,
);

// Bodies
final fontStyleBody1 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 16,
);
final fontStyleBody2 = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 14,
);
final fontStyleCaption = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 12,
);
final fontStyleOverline = TextStyle(
  backgroundColor: Colors.transparent,
  color: colorGrey[900],
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 10,
  decoration: TextDecoration.overline,
);
// Buttons
const fontStyleButton = TextStyle(
  backgroundColor: Colors.transparent,
  color: Colors.white,
  fontFamily: 'Roboto',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
  fontSize: 14,
  letterSpacing: 1.25,
);

// COLORS
const colorFacebook = Color(0xFF3B5998);
const colorGoogle = Color(0xFFEA4335);
const colorApple = Color(0xFF000000);

const MaterialColor colorPrimarySwatch = MaterialColor(0xFF00a859, {
  50: Color(0xFF30f299),
  100: Color(0xFF1fdb84),
  200: Color(0xFF0ec972),
  300: Color(0xFF09bd69),
  400: Color(0xFF00a859),
  500: Color(0xFF038f4d),
  600: Color(0xFF027840),
  700: Color(0xFF026637),
  800: Color(0xFF02572f),
  900: Color(0xFF014726),
});

const MaterialColor colorSecondarySwatch = MaterialColor(0xFF8292F7, {
  50: Color(0xFFB2BCFF),
  100: Color(0xFFB2BCFF),
  200: Color(0xFFB2BCFF),
  300: Color(0xFFB2BCFF),
  400: Color(0xFF8292F7),
  500: Color(0xFF8292F7),
  600: Color(0xFF8292F7),
  700: Color(0xFF3446B8),
  800: Color(0xFF3446B8),
  900: Color(0xFF3446B8),
});

const MaterialColor colorGrey = MaterialColor(0xFF4D4D4D, {
  50: Color(0xFFF2F2F2),
  100: Color(0xFFF2F2F2),
  200: Color(0xFFD5D5D5),
  300: Color(0xFFD5D5D5),
  400: Color(0xFF939598),
  500: Color(0xFF939598),
  600: Color(0xFF4D4D4D),
  700: Color(0xFF4D4D4D),
  800: Color(0xFF343434),
  900: Color(0xFF343434),
});

const colorWarning = Color(0xFFFFB717);
const colorDanger = Color(0xFFd43742);
const colorSuccess = Color(0xFF60c227);
const colorBronze = Color(0xFFCD7F32);
const colorPrata = Color(0xFFa3a2a2);
const colorGold = Color(0xFFf0cd16);
const colorDiamond = Color(0xFF9bdceb);

// TEXT MASK
final emailValidate = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final maskFormatterPhone = TextInputMask(mask: ['(99) 9999-9999', '(99) 9 9999-9999']);
final maskFormatterDate = TextInputMask(mask: '99/99/9999');
final maskFormatterCnpj = TextInputMask(mask: ['99.999.999/9999-99']);
final maskFormatterRG = TextInputMask(mask: ['9.999.999-99']);
final maskFormatterRGEmit = TextInputMask(mask: ['AAA/AA']);
final maskFormatterCep = TextInputMask(mask: '99999-999');
final maskFormatterCpf = TextInputMask(mask: ['999.999.999-99']);
final maskFormatterMoney = TextInputMask(mask: '999.999,99', placeholder: '0', maxPlaceHolders: 3, reverse: true);

// FORMATAÇÃO DE MOEDA
final oCcy = NumberFormat.simpleCurrency(locale: 'pt_BR');

// ARREDONDAMENTO DOS ESTIOS
OutlineRounded({Color? color}) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(defaultRadius8),
  borderSide: BorderSide(
    width: 2,
    color: color ?? appNormalPrimaryColor
  )
);
RoundedButton() => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(defaultRadius8)
);

Color getColorByStatus(status) {
  return status == 'offline' ? colorDanger
      : status == 'ocupado' ? colorWarning
      : status == 'online' ? colorSuccess : colorSuccess;
}