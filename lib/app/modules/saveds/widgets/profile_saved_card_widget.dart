import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_saved_model.dart';
import 'package:delivery_servicos/app/modules/profile/profile_page.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_pages.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';

class ProfilesSavedCardWidget extends StatelessWidget {
  final ProfileSavedModel profile;
  const ProfilesSavedCardWidget({required this.profile, Key? key}) : super(key: key);

  goToProfileDetails() async {
    ProfileModel profileLoaded = await FirebaseService.getProfileModelData(profile.firebaseId);
    Get.lazyPut(() => ProfileController()); // Criar um controller temporário
    Get.to(() => ProfilePage(profileView: profileLoaded, backRoute: Routes.saveds));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToProfileDetails(),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
            side: BorderSide(width: 2, color: appLightGreyColor.withOpacity(0.5))
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    image: profile.image.isEmpty ? null : DecorationImage(
                        image: Image.memory(Uint8List.fromList(profile.image)).image,
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(defaultCircularRadius64),
                    color: appExtraLightGreyColor.withOpacity(0.5)
                ),
                child: Visibility(
                  visible: profile.image.isEmpty,
                  child: Icon(Icons.image_not_supported, color: appLightGreyColor,),
                ),
              ),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                      style: appStyle.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                    const SizedBox(height: 4,),
                    Text(getMaskedPhoneNumber(profile.phoneNumber),
                      style: appStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appNormalGreyColor),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: appLightGreyColor),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
