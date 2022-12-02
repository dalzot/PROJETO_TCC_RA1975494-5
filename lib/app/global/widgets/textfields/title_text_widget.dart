import '../../../../core/values/text_style_type.dart';
import '../../constants/styles_const.dart';

import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;
  final int type;
  final EdgeInsetsGeometry padding;
  const TitleTextWidget({
    Key? key,
    required this.text,
    this.type = TextStyleType.TITLE_H4,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: getTextStyle(type),
      ),
    );
  }

  TextStyle getTextStyle(int type) {
    switch (type) {
      case TextStyleType.TITLE_H1: return fontStyleH1;
      case TextStyleType.TITLE_H2: return fontStyleH2;
      case TextStyleType.TITLE_H3: return fontStyleH3;
      case TextStyleType.TITLE_H4: return fontStyleH4;
      case TextStyleType.TITLE_H5: return fontStyleH5;
      case TextStyleType.TITLE_H6: return fontStyleH6;
      case TextStyleType.SUBTITLE_S1: return fontStyleSubtitle1;
      case TextStyleType.SUBTITLE_S2: return fontStyleSubtitle2;
      case TextStyleType.BODY1: return fontStyleBody1;
      case TextStyleType.BODY2: return fontStyleBody2;
      case TextStyleType.CAPTION: return fontStyleCaption;
      case TextStyleType.OVERLINE: return fontStyleOverline;
      default: return fontStyleH4;
    }
  }
}
