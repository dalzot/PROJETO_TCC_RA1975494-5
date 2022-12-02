import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:get/get.dart';

import '../../constants/styles_const.dart';

class TextFieldWidget extends StatefulWidget {
  final String? label;
  final TextInputType type;
  final TextEditingController controller;
  final Icon? icon;
  final FaIcon? iconFa;
  final Widget? suffixIcon;
  final Color? iconColor;
  final String? errorMsg;
  final IconData? errorIcon;
  final bool errorStatus;
  final Function? validator;
  final List<TextInputFormatter>? inputFormatter;
  final dynamic maxLines;
  final EdgeInsets padding;
  final int maxLength;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int minLines;
  final Function(String? value)? onChanged;
  final bool enableField;
  final bool isMultiline;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final String? hintText;
  final Color? hintColor;
  final bool showBorder;
  const TextFieldWidget(
      {Key? key,
      this.label,
      this.type = TextInputType.text,
      required this.controller,
      this.icon,
      this.iconFa,
      this.suffixIcon,
      this.iconColor,
      this.errorMsg,
      this.errorIcon,
      this.errorStatus = false,
      this.validator,
      this.onChanged,
      this.enableField = true,
      this.inputFormatter,
      this.maxLines = 1,
      this.padding = const EdgeInsets.symmetric(vertical: 8),
      this.maxLength = 200,
      this.textInputAction = TextInputAction.done,
      this.textCapitalization = TextCapitalization.none,
      this.minLines = 1,
      this.onPressed,
      this.backgroundColor,
      this.hintText,
      this.hintColor,
      this.showBorder = true,
      this.isMultiline = false})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        onChanged: widget.onChanged,
        enabled: widget.enableField,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        maxLength: widget.maxLength,
        style: Get.textTheme.titleMedium,
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType: widget.type,
        minLines: widget.minLines,
        inputFormatters: widget.inputFormatter,
        decoration: InputDecoration(
          border: OutlineRounded(color: !widget.showBorder ? Colors.transparent : null),
          enabledBorder: OutlineRounded(color: !widget.showBorder ? Colors.transparent : null),
          focusedBorder: OutlineRounded(),
          fillColor: widget.backgroundColor,
          filled: widget.backgroundColor != null ? true : false,
          counter: const Offstage(),
          labelText: widget.isMultiline ? null : widget.label,
          hintText: widget.hintText ?? widget.label,
          hintStyle: appStyle.bodyMedium
              ?.copyWith(color: widget.hintColor ?? appDarkPrimaryColor.withOpacity(0.5)),
          errorText: (widget.errorStatus) ? widget.errorMsg : null,
          isDense: true,
          prefixIcon: widget.iconFa != null ? SizedBox(
            width: 32,
            height: 32,
            child: Center(child: widget.iconFa),
          ) : widget.icon,
          prefixIconColor: widget.iconColor ?? appNormalPrimaryColor,
          suffixIcon: widget.suffixIcon ?? ((widget.errorStatus && widget.errorIcon != null)
              ? IconButton(
                  icon: Icon(widget.errorIcon!),
                  onPressed: widget.onPressed,
                )
              : null),
        ),
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!.call(value);
          }
          return null;
        },
      ),
    );
  }
}
