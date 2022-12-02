import '../../../core/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../global/widgets/small/logo_app.dart';
import 'controller/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appNormalPrimaryColor,
      body: smallLogoApp(),
    );
  }
}
