import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../routes/app_pages.dart';
import '../drawer/drawer_widget.dart';
import '../menus/bottom_menu_widget.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String pageTitle;
  final Widget? pageTitleWidget;
  final bool showBottomMenu;
  final bool showDrawerMenu;
  final String? backRoute;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Widget? bottomBar;
  
  const CustomScaffold({
    required this.body, 
    required this.pageTitle,
    this.pageTitleWidget,
    this.showBottomMenu = true,
    this.showDrawerMenu = true,
    this.actions,
    this.backRoute,
    this.floatingActionButton,
    this.backgroundColor,
    this.bottomBar,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? appBackgroundColorDark,
      bottomNavigationBar: showBottomMenu ? BottomMenuWidget() : bottomBar,
//      persistentFooterButtons: showBottomMenu
//          ? [BottomMenuWidget()] : null,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[appNormalPrimaryColor, appDarkPrimaryColor],
            ),
          ),
        ),
        title: pageTitleWidget ?? Text(pageTitle),
        centerTitle: true,
        actions: actions,
        leading: showDrawerMenu ? null : IconButton(
            onPressed: () => Get.offAllNamed(backRoute ?? Routes.home),
            icon: Icon(Icons.close)),
      ),
      drawer: showDrawerMenu ? DrawerWidget() : null,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
