import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../../global/constants/styles_const.dart';

class LevelProfileWidget extends StatelessWidget {
  final int level;
  const LevelProfileWidget(this.level, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(getIconFromLevel(level),
        color: getColorFromLevel(level), size: 16);
  }

  getIconFromLevel(level) {
    if(level <= 2) {
      return Icons.verified_user_rounded;
    } else {
      return Icons.verified_rounded;
    }
  }

  getColorFromLevel(level) {
    switch(level) {
      case 1: return appNormalPrimaryColor; // Verificado
      case 2: return colorSuccess; // Confiável
      case 3: return colorBronze; // Perfil Bronze
      case 4: return colorPrata; // Perfil Prata
      case 5: return colorGold; // Perfil Gold
      case 6: return colorDiamond; // Perfil Diamond
    }
  }
}
