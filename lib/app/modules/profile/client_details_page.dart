import 'package:delivery_servicos/app/modules/profile/widgets/view_profile_widget.dart';
import 'package:flutter/material.dart';

import 'models/profile_model.dart';
import 'widgets/personal_details_widget.dart';

class ClientDetailsPage extends StatelessWidget {
  final ProfileModel? profileView;
  const ClientDetailsPage({
    this.profileView,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return profileView != null
        ? ViewProfileWidget(profileView: profileView!)
        : const PersonalDetailsWidget();
  }
}
