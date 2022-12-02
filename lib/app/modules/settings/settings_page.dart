import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/body/custom_scaffold.dart';
import '../../global/widgets/lists/empty_list_widget.dart';
import 'controller/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageTitle: 'Configurações',
      body: EmptyListWidget(),
    );
  }
}
