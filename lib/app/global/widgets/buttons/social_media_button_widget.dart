import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../constants/styles_const.dart';

class SocialMediaButtonWidget extends StatefulWidget {
  final String imagePath;
  final Function? function;
  const SocialMediaButtonWidget(
      {Key? key, required this.imagePath, this.function})
      : super(key: key);

  @override
  State<SocialMediaButtonWidget> createState() =>
      _SocialMediaButtonWidgetState();
}

class _SocialMediaButtonWidgetState extends State<SocialMediaButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: defaultRadius16,
      borderRadius: defaultBorderRadius32,
      child: Container(
        decoration: BoxDecoration(
          color: appWhiteColor,
          borderRadius: defaultBorderRadius32,
          //border: Border.all(width: 1.5, color: appNormalPrimaryColor.withOpacity(0.5))
        ),
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: appWhiteColor,
              radius: 16,
              child: Image.asset(
                widget.imagePath,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                height: 24,
                width: 24,
              ),
            ),
            Text(
              "OOGLE",
              style: fontStyleBody1.copyWith(color: colorGrey.withOpacity(0.425)),
            ),
          ],
        ),
      ),
      onTap: () => widget.function!(),
    );
  }
}
