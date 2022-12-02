import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../constants/constants.dart';
import '../../constants/styles_const.dart';

Widget smallLogoAppWithBack() => Center(
  child: CircleAvatar(
    radius: 72,
    backgroundColor: appNormalPrimaryColor.withOpacity(0.25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(appIcon, width: 84, height: 84),
        Text(appName,
          style: appStyle.titleLarge?.copyWith(
            color: appNormalPrimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);

Widget smallLogoApp() => Center(
  child: CircleAvatar(
    radius: 128,
    backgroundColor: appLightGreyColor.withOpacity(0.5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(appIcon, width: 196, height: 196),
        Text(appName,
          style: appStyle.titleLarge?.copyWith(
            color: appWhiteColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);