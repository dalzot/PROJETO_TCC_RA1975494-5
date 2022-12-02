import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../core/theme/app_color.dart';

class DrawerListTileWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onTap;
  final String currentRoute;
  const DrawerListTileWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      iconColor: appDarkGreyColor,
      child: ListTile(
          selected: Get.currentRoute == currentRoute,
          selectedTileColor: appExtraLightGreyColor,
          title: Text(text,
              style: Get.textTheme.subtitle2!.copyWith(
                  color: Get.currentRoute == currentRoute
                      ? Get.theme.primaryColor
                      : appDarkGreyColor)),
          leading: Icon(
            icon,
            color: Get.currentRoute == currentRoute
                ? Get.theme.primaryColor
                : appDarkGreyColor,
          ),
          // irá chamar pela requisição sempre que for para a navegação do budget
          // assim irá listar os orçamentos mais recentes..
          // _budgetController.findAllBudgetRequests();
          onTap: onTap),
    );
  }
}
