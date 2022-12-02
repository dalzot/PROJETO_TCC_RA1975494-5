import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../constants/constants.dart';

class CustomInkWell extends StatelessWidget {
  final Color? backgroundColor;
  final Color? splashColor;
  final BorderRadius? borderRadius;
  final Function()? onTap;
  final Widget? child;

  const CustomInkWell({
    this.backgroundColor,
    this.splashColor,
    this.borderRadius,
    this.onTap,
    this.child,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? appExtraLightGreyColor,
      borderRadius: borderRadius ?? defaultBorderRadius8,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? appLightPrimaryColor.withOpacity(0.25),
        borderRadius: borderRadius ?? defaultBorderRadius8,
        child: child,
      ),
    );
  }
}
