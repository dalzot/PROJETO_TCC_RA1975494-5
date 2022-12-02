import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/profile_controller.dart';
import 'models/profile_model.dart';
import 'widgets/personal_details_widget.dart';

class ClientDetailsPage extends GetView<ProfileController> {
  ProfileModel? profileView;
  ClientDetailsPage({
    this.profileView,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersonalDetailsWidget(profileView: profileView);
  }
}
