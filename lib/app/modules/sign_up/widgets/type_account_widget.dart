import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';

class TypeAccountWidget extends StatelessWidget {
  final String type;
  const TypeAccountWidget({
    required this.type,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: defaultBorderRadius8,
          border: Border.all(width: 2, color: appLightGreyColor)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: checkUserType(type) ? 8 : 14),
            child: Icon(checkUserType(type)
                ? Icons.build_rounded : Icons.person_search_rounded,
                color: appNormalPrimaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Conta",
                style: fontStyleBody1.copyWith(color: appNormalGreyColor),
              ),
              Text(checkUserType(type) ? "PROFISSIONAL" : "CLIENTE",
                style: fontStyleBody1.copyWith(color: appNormalPrimaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
