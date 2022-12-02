import 'package:delivery_servicos/app/modules/profile/widgets/personal_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/profile_controller.dart';
import 'models/profile_model.dart';

class ProfessionalDetailsPage extends GetView<ProfileController> {
  final ProfileModel? profileView;
  const ProfessionalDetailsPage({
    this.profileView,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersonalDetailsWidget(profileView: profileView);
  }
}
