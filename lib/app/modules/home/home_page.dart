import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import 'controller/home_controller.dart';
import 'home_client_page.dart';
import 'home_professional_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return checkUserType(controller.userLogged.profileType)
        ? const HomeProfessionalPage() : const HomeClientPage();
  }
}
