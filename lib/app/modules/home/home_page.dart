import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/global/widgets/modal_sheet/modal_bottom_sheet.dart';
import 'package:delivery_servicos/app/modules/announce/widgets/announce_card_widget.dart';
import 'package:delivery_servicos/app/modules/home/widgets/home_banner_ads_widget.dart';
import 'package:delivery_servicos/app/modules/home/widgets/home_filters_widget.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../core/mixin/loader_content.dart';
import '../../../core/theme/app_color.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/body/custom_scaffold.dart';
import '../profile/widgets/professional_card_widget.dart';
import 'controller/home_controller.dart';
import 'home_client_page.dart';
import 'home_professional_page.dart';
import 'widgets/home_banner_slider_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return checkUserType(controller.userLogged.profileType)
        ? const HomeProfessionalPage() : const HomeClientPage();
  }
}
