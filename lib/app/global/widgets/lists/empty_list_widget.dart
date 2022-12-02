import 'package:delivery_servicos/app/global/widgets/buttons/custom_inkwell.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../constants/constants.dart';

class EmptyListWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Function()? onTap;
  const EmptyListWidget({
    this.message,
    this.icon,
    this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomInkWell(
        backgroundColor: onTap != null ? appExtraLightGreyColor : Colors.transparent,
        borderRadius: defaultBorderRadius8,
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: defaultBorderRadius16
          ),
          elevation: onTap != null ? 0 : 2,
          color: onTap != null ? Colors.transparent : appExtraLightGreyColor,
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(message ?? 'Não encontramos nenhum registro',
                  textAlign: TextAlign.center,),
                const SizedBox(height: 8),
                Icon(icon ?? Icons.sentiment_neutral_rounded, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
