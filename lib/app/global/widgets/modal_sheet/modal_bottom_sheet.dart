import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../constants/styles_const.dart';
import '../buttons/action_button_widget.dart';

void openModalBottomSheet(context, {
  required Widget child,
  bool expandedBody = false,
  bool showClose = false,
  bool hideButton = false,
  String? title,
  Function()? onTapButton,
  String? textButton,
  IconData? iconButton,
  Function()? clearFilters,
  double heightModal = 284,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        )
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: expandedBody ? null : heightModal,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorGrey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 4,
                  width: 64,
                ),
                SizedBox(height: showClose ? 12 : 24.0),
                Row(
                  mainAxisAlignment: showClose
                      ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: [
                    if(title != null)
                      Text(title,
                          style: fontStyleSubtitle1.copyWith(
                              fontWeight: FontWeight.bold
                          )),
                    if(showClose)
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded))
                  ],
                ),
                SizedBox(height: showClose ? 16 : 32.0),
              ],
            ),
            expandedBody ? Expanded(child: child) : child,
            if(!hideButton) Column(
              children: [
                if(!showClose) const SizedBox(height: 32.0),
                if(clearFilters != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ActionButtonWidget(
                      height: 32,
                      icon: Icons.backspace_rounded,
                      title: "LIMPAR FILTROS",
                      function: clearFilters,
                      isInvertedColors: true,
                      borderRadius: 8,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ActionButtonWidget(
                    icon: iconButton,
                    title: (textButton ?? "FECHAR").toUpperCase(),
                    function: onTapButton ?? () => Navigator.pop(context),
                    color: appNormalPrimaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
}

Widget componentButtonPicker({
  required String label,
  required IconData iconType,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(iconType,
          color: appNormalPrimaryColor,
          size: 52,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    ),
  );
}

Widget componentButtonIconText({
  required String label,
  required String content,
  required IconData iconType,
  IconData? iconRight,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius8,
        color: appExtraLightGreyColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconType,
              color: appNormalPrimaryColor,
              size: 52,
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(label != '') ...[
                  Text(label),
                  const SizedBox(height: 8),
                ],
                Text(content, style: appStyle.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: iconRight != null,
              child: Column(
                children: [
                  const SizedBox(width: 16),
                  Icon(iconRight,
                    color: appLightGreyColor,
                    size: 32,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}