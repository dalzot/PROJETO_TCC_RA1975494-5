import '../../../../core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/styles_const.dart';

class ActionButtonWidget extends StatefulWidget {
  final String title;
  final Function? function;
  final Color? color;
  final Color textColor;
  final bool isInvertedColors;
  final double height;
  final double borderRadius;
  final IconData? icon;

  const ActionButtonWidget(
      {Key? key,
        required this.title,
        this.function,
        this.color,
        this.textColor = Colors.white,
        this.height = 48,
        this.borderRadius = 16,
        this.isInvertedColors = false,
        this.icon
      }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActionButtonWidget();
}

class _ActionButtonWidget extends State<ActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: Get.width,
      child: ElevatedButton(
        onPressed: (widget.function != null) ? () => widget.function!() : null,
        style: ElevatedButton.styleFrom(
          shape: widget.isInvertedColors
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              side: BorderSide(
                color: widget.color ?? appNormalPrimaryColor,
                width: 1,
              ),
            )
          : RoundedButton(),
          backgroundColor: widget.isInvertedColors
              ? Colors.white : (widget.color ?? appNormalPrimaryColor),
          elevation: 0,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(widget.icon != null) Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(widget.icon,
                  size: widget.height < 48 ? 16 : null,
                  color: widget.isInvertedColors ? (widget.color ?? appNormalPrimaryColor) : Colors.white),
            ),
            Text(
              widget.title,
              style: Get.textTheme.labelLarge?.copyWith(
                  color: widget.isInvertedColors ? (widget.color ?? appNormalPrimaryColor) : Colors.white),
            ),
            if(widget.icon != null) SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
