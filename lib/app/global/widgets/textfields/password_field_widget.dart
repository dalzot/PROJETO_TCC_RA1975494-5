import '../../../../core/theme/app_color.dart';
import '../../constants/constants.dart';
import '../../constants/styles_const.dart';
import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatefulWidget {
  final String? label;
  final TextInputType type;
  final TextEditingController controller;
  final Icon? icon;
  final Color? iconColor;
  final Color? hintColor;
  final String? errorMsg;
  final IconData? errorIcon;
  final bool errorStatus;
  final Function? validator;
  final bool enableField;
  const PasswordFieldWidget({
    Key? key,
    this.label,
    this.type = TextInputType.text,
    required this.controller,
    this.icon,
    this.iconColor,
    this.hintColor,
    this.errorMsg,
    this.errorIcon,
    this.errorStatus = false,
    this.validator,
    this.enableField = true,
  }) : super(key: key);

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _isPassObscure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.type,
        obscureText: _isPassObscure,
        enableSuggestions: false,
        enabled: widget.enableField,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: fontStyleSubtitle1,
          hintText: widget.label,
          hintStyle: appStyle.bodyMedium
              ?.copyWith(color: widget.hintColor ?? appDarkPrimaryColor.withOpacity(0.5)),
          errorText: (widget.errorStatus) ? widget.errorMsg : null,
          isDense: true,
          border: OutlineRounded(),
          enabledBorder: OutlineRounded(),
          focusedBorder: OutlineRounded(),
          prefixIcon: widget.icon,
          prefixIconColor: widget.iconColor ?? appNormalPrimaryColor,
          suffixIcon: IconButton(
            icon: Icon(
              _isPassObscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPassObscure = !_isPassObscure;
              });
            },
          ),
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
