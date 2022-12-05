import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../global/widgets/small/custom_containers_widget.dart';
import '../models/profile_model.dart';
import 'profile_widgets.dart';

class ViewProfileWidget extends StatelessWidget {
  final ProfileModel profileView;
  const ViewProfileWidget({
    required this.profileView,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 164,
          child: Stack(
            children: [
              InkWell(
                onTap: profileView.banner.isEmpty
                    ? null : () => showDialog(
                    context: context,
                    builder: (bContext) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Image ampliada'),
                        centerTitle: true,
                      ),
                      body: SingleChildScrollView(
                        child: Image.memory(Uint8List.fromList(profileView.banner),
                            fit: BoxFit.fitWidth),
                      ),
                    )),
                child: Container(
                  width: Get.width,
                  height: 148,
                  decoration: BoxDecoration(
                    color: appLightGreyColor,
                    image: profileView.banner.isEmpty ? null
                        : DecorationImage(image: Image.memory(Uint8List.fromList(profileView.banner)).image,
                        fit: BoxFit.fitWidth
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: defaultPadding32,
                right: defaultPadding32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: appBackgroundColor,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: appExtraLightGreyColor,
                        child: Material(
                          color: appExtraLightGreyColor,
                          borderRadius: defaultBorderRadius64,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: profileView.image.isEmpty ? null
                                : Image.memory(Uint8List.fromList(profileView.image), fit: BoxFit.cover,).image,
                            child: Visibility(
                                visible: profileView.image.isEmpty,
                                child: const Icon(Icons.image_not_supported, color: appLightGreyColor)),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: defaultPadding16,
                  bottom: 2,
                  child: RateContainer(profileView.rate)),
              Positioned(
                  right: defaultPadding16,
                  bottom: 2,
                  child: StatusContainer(profileView)),
            ],
          ),
        ),
        ProfileBody(profileView, context),
      ],
    );
  }
}