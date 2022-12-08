import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/body/custom_scaffold.dart';
import 'controller/about_controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: CustomScaffold(
          showBottomMenu: false,
          pageTitle: 'Sobre',
          body: Column(
            children: [

            ],
          )
      ),
    );
  }
}
