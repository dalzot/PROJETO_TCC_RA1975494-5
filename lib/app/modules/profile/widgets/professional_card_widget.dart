import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/app/modules/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import 'level_profile_widget.dart';

class ProfessionalCardWidget extends StatelessWidget {
  final ProfileModel profile;
  const ProfessionalCardWidget({required this.profile, Key? key}) : super(key: key);

  goToProfileDetails() {
    Get.lazyPut(() => ProfileController(profileParam: profile)); // Criar um controller temporário
    Get.to(() => ProfilePage(profileView: profile));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appWhiteColor,
      child: Column(
        children: [
          Container(height: 1, color: appLightGreyColor),
          Container(height: 1, color: appExtraLightGreyColor),
          SizedBox(
            height: 174,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  SizedBox(
                    child: InkWell(
                      onTap: () {
                        goToProfileDetails();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
//                              height: 112,
                              width: 112,
                              decoration: BoxDecoration(
                                  image: profile.image.isEmpty ? null : DecorationImage(
                                      image: Image.memory(Uint8List.fromList(profile.image)).image,
                                      fit: BoxFit.cover
                                  ),
                                  color: appExtraLightGreyColor,
                              ),
                              child: Visibility(
                                visible: profile.image.isEmpty,
                                child: Icon(Icons.image_not_supported, color: appLightGreyColor,),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2,),
                          Container(
                            width: 112,
                            color: appExtraLightGreyColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${profile.rate.toStringAsFixed(1).replaceAll('.', ',')}',
                                    style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const Icon(Icons.star_rounded, color: colorWarning),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 2,),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          color: appExtraLightGreyColor,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if(profile.level > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: LevelProfileWidget(profile.level),
                                    ),
                                  Expanded(
                                    child: Text(profile.name,
                                      style: appStyle.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: profile.expertises
                                  .map((service) => Text("- $service",
                                style: appStyle.bodySmall,
                              )).toList(),
                            )
                        ),
                        Container(height: 2, color: appExtraLightGreyColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.circle,
                                    size: 10,
                                    color: getColorByStatus(profile.status)),
                                const SizedBox(width: 2),
                                Text(profile.status,
                                  style: appStyle.bodySmall,
                                ),
                              ],
                            ),
                            Text("${profile.addressCity}, ${profile.addressProvince.toUpperCase()}",
                              style: appStyle.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2,),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            color: appExtraLightGreyColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Ver Profissional', style: appStyle.bodySmall
                                    ?.copyWith(color: appDarkPrimaryColor)),
                              ],
                            ),
                          ),
                          onTap: () {
                            goToProfileDetails();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: appNormalGreyColor),
          Container(height: 1, color: appNormalGreyColor.withOpacity(0.75)),
          Container(height: 1, color: appNormalGreyColor.withOpacity(0.5)),
          Container(height: 1, color: appNormalGreyColor.withOpacity(0.25)),
        ],
      ),
    );
  }
}
