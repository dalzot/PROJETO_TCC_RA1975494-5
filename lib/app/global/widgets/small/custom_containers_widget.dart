import 'package:delivery_servicos/app/modules/chat/chat_details.dart';
import 'package:delivery_servicos/app/modules/chat/controller/chat_controller.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:delivery_servicos/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/util/global_functions.dart';
import '../../../../core/util/open_social_links.dart';
import '../../../../core/values/enums.dart';
import '../../../modules/profile/models/profile_model.dart';
import '../../constants/constants.dart';
import '../../constants/styles_const.dart';
import '../buttons/custom_inkwell.dart';
import '../modal_sheet/modal_bottom_sheet.dart';

Widget CustomContainerTitle(String title, {required Widget child, String? help}) {
  return Container(
    decoration: BoxDecoration(
        color: appExtraLightGreyColor,
        borderRadius: defaultBorderRadius8
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInkWell(
            onTap: help != null ? () {
              globalAlertDialog(
                title: title,
                labelActionButton: 'entendi',
                onPressedAction: () => Get.back(),
                text: help,
              );
            } : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: appStyle.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Visibility(
                  visible: help != null,
                  child: const Icon(Icons.help_outline_rounded, color: appNormalPrimaryColor, size: 16,),
                )
              ],
            ),
          ),
          const Divider(height: 8, thickness: 1, color: appLightGreyColor),
          const SizedBox(height: 6),
          child,
        ],
      ),
    ),
  );
}

Widget OpenAddressOnMap(ProfileModel profile) {
  return Container(
    decoration: BoxDecoration(
        color: appWhiteColor,
        borderRadius: defaultBorderRadius8
    ),
    height: 48,
    child: CustomInkWell(
      backgroundColor: appWhiteColor,
      onTap: () async {
        String addressToSearch = '${profile.addressStreet}, '
            '${profile.addressNumber} - ${profile.addressDistrict}, '
            '${profile.addressCity} - ${profile.addressProvince}, '
            '${getMaskedZipCode(profile.addressCEP)}';

//          try {
//            GeoData address = await Geocoder2.getDataFromAddress(
//                address: addressToSearch.replaceAll(' ', '+'),
//                googleMapApiKey: googleMapsAPI);
//            //https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$googleMapApiKey
//            print("address: ${address.latitude} : ${address.longitude}\n${address.address}");
//          } catch(e,st) {
//            printException('getDataFromAddress', e, st);
//          }
//          print("addressToSearch: ${addressToSearch.replaceAll(' ', '+')}");

        OpenSocialLink().openGoogleMaps(addressToSearch);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
                width: 24,
                child: FaIcon(FontAwesomeIcons.mapPin,
                    size: 24,
                    color: appNormalPrimaryColor)),
            Text('ABRIR NO GOOGLE MAPS',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: appStyle.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400)),
            const Icon(Icons.arrow_forward_ios_rounded, color: appLightGreyColor),
          ],
        ),
      ),
    ),
  );
}

Widget SkillContainer(String text) {
  return Container(
    decoration: BoxDecoration(
        color: appDarkPrimaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4)
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text, style: appStyle.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
    ),
  );
}

Widget RateContainer(double rate) {
  return Container(
    decoration: BoxDecoration(
        color: appExtraLightGreyColor,
        borderRadius: BorderRadius.circular(4)
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: colorWarning),
          const SizedBox(width: 4),
          Text('${rate.toStringAsFixed(1).replaceAll('.', ',')}',
              style: appStyle.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}


Widget LongButton(String title, ContactButtonType buttonType, BuildContext context,
{String phoneNumber = '', String phoneNumber2 = '', ProfileModel? profileParam, String profileId = ''}) {
  IconData iconData =
  buttonType == ContactButtonType.call ? FontAwesomeIcons.phoneAlt
      : buttonType == ContactButtonType.chat ? FontAwesomeIcons.solidComment
      : FontAwesomeIcons.shareAlt;
  return SizedBox(
    height: 64,
    child: CustomInkWell(
      onTap: () async {
        switch(buttonType) {
          case ContactButtonType.call:
            openModalBottomSheet(context,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    componentButtonIconText(
                        label: 'Número Principal',
                        content: getMaskedPhoneNumber(phoneNumber),
                        iconType: Icons.phone_forwarded_rounded,
                        iconRight: Icons.arrow_forward_ios_rounded,
                        onTap: () {
                          Navigator.of(context).pop();
                          OpenSocialLink().callTo(phoneNumber);
                        }),
                    Visibility(
                      visible: phoneNumber2.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          componentButtonIconText(
                              label: 'Número Opcional',
                              content: getMaskedPhoneNumber(phoneNumber2),
                              iconType: Icons.phone_forwarded_rounded,
                              iconRight: Icons.arrow_forward_ios_rounded,
                              onTap: () {
                                Navigator.of(context).pop();
                                OpenSocialLink().callTo(phoneNumber2);
                              }),
                        ],
                      ),
                    )
                  ],
                ),
                heightModal: phoneNumber2.isEmpty ? 285 : 384,
                title: "Escolha uma opção");
            break;
          case ContactButtonType.chat:
            if(profileParam != null || profileId.isNotEmpty) {
              openModalBottomSheet(context,
                  child: componentButtonIconText(
                      label: '',
                      content: 'Iniciar conversa',
                      iconType: Icons.mark_chat_read_rounded,
                      iconRight: Icons.arrow_forward_ios_rounded,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await globalFunctionOpenChat(profileParam: profileParam, profileId: profileId);
                      }),
                  heightModal: 285,
                  title: "Escolha uma opção");
            }
            break;
          case ContactButtonType.share:
          // TODO: Handle this case.
            break;
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(iconData,
                size: 24,
                color: appNormalPrimaryColor),
            Text(title, style: appStyle.bodySmall?.copyWith(color: appNormalPrimaryColor)),
          ],
        ),
      ),
    ),
  );
}

Widget GetIconByStatus(String status, {double? size}) {
  IconData icon = Icons.close_rounded;
  Color color = colorDanger;
  switch(status) {
    case 'enviada':
      icon = Icons.subdirectory_arrow_right_rounded;
      color = appNormalPrimaryColor;
      break;
    case 'aprovada':
      icon = Icons.check_rounded;
      color = colorSuccess;
      break;
  }
  return Icon(icon, color: color, size: size,);
}