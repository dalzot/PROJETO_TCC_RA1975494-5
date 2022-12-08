import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/util/global_functions.dart';
import '../../../../core/util/open_social_links.dart';
import '../../../../core/values/enums.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import '../../../global/widgets/small/custom_containers_widget.dart';

Widget IconButtonSocial(String social, SocialButtonType type, String openTo) {
  IconData iconData =
  type == SocialButtonType.whatsapp ? FontAwesomeIcons.whatsapp
      : type == SocialButtonType.linkedin ? FontAwesomeIcons.linkedinIn
      : type == SocialButtonType.instagram ? FontAwesomeIcons.instagram
      : type == SocialButtonType.telegram ? FontAwesomeIcons.telegramPlane
      : FontAwesomeIcons.facebookF;
  return Container(
    decoration: BoxDecoration(
        color: appWhiteColor,
        borderRadius: defaultBorderRadius8
    ),
    height: 48,
    child: CustomInkWell(
      backgroundColor: appWhiteColor,
      onTap: () async {
        switch(type) {
          case SocialButtonType.whatsapp:
            OpenSocialLink().sendWhatsMessage(openTo);
            break;
          case SocialButtonType.telegram:
            OpenSocialLink().sendTelegramMessage(openTo);
            break;
          case SocialButtonType.instagram:
            OpenSocialLink().sendInstagram(openTo);
            break;
          case SocialButtonType.linkedin:
            OpenSocialLink().sendLinkedin(openTo);
            break;
          case SocialButtonType.facebook:
            OpenSocialLink().sendFacebook(openTo);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding16),
        child: Row(
          children: [
            SizedBox(
                width: 24,
                child: FaIcon(iconData,
                    size: 24,
                    color: appNormalPrimaryColor)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(type == SocialButtonType.whatsapp
                  ? '+55 ${getMaskedPhoneNumber(openTo)}'
                  : '@$social',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style: appStyle.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400)),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: appLightGreyColor),
          ],
        ),
      ),
    ),
  );
}

Widget AddressByProfile(ProfileModel profile) {
  return CustomContainerTitle('Endereço',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cidade: ', style: appStyle.bodyMedium),
            Expanded(
              child: Text('${profile.addressCity} - ${profile.addressProvince} '
                  '(${getMaskedZipCode(profile.addressCEP)})',
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logradouro: ', style: appStyle.bodyMedium),
            Expanded(
              child: Text('${profile.addressStreet}',
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bairro: ', style: appStyle.bodyMedium),
            Expanded(
              child: Text('${profile.addressDistrict}, nº ${profile.addressNumber}',
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        Visibility(
          visible: profile.addressComplement.toString().trim() != '',
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Complemento: '),
                Text(profile.addressComplement.toString()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        OpenAddressOnMap(profile),
      ],
    ),
  );
}

Widget SocialLinksByProfile(ProfileModel profile) {
  return CustomContainerTitle('Redes Sociais',
      help: 'Essas são as redes sociais do ${profile.name}, '
          'você pode segui-lo para acompanhar de perto seus serviços',
      child: Column(
        children: [
          Visibility(
            visible: profile.whatsapp != '',
            child: IconButtonSocial(profile.whatsapp, SocialButtonType.whatsapp, profile.whatsapp),
          ),
          Visibility(
            visible: profile.instagram != '',
            child: Column(
              children: [
                const SizedBox(height: defaultPadding8),
                IconButtonSocial(profile.instagram, SocialButtonType.instagram, profile.instagram),
              ],
            ),
          ),
          Visibility(
            visible: profile.facebook != '',
            child: Column(
              children: [
                const SizedBox(height: defaultPadding8),
                IconButtonSocial(profile.facebook, SocialButtonType.facebook, profile.facebook),
              ],
            ),
          ),
          Visibility(
            visible: profile.linkedin != '',
            child: Column(
              children: [
                const SizedBox(height: defaultPadding8),
                IconButtonSocial(profile.linkedin, SocialButtonType.linkedin, profile.linkedin),
              ],
            ),
          ),
          Visibility(
            visible: profile.telegram != '',
            child: Column(
              children: [
                const SizedBox(height: defaultPadding8),
                IconButtonSocial(profile.telegram, SocialButtonType.telegram, profile.telegram),
              ],
            ),
          ),
          Visibility(
            visible: profile.facebook == '' &&
                profile.linkedin == '' &&
                profile.instagram == '' &&
                profile.telegram == '' &&
                profile.whatsapp == '',
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhuma rede social adicionada'),
              ),
            ),
          ),
        ],
      )
  );
}

Widget PaymentsMethodsProfile(ProfileModel profile) {
  return checkUserType(profile.profileType) ? Column(
    children: [
      const SizedBox(height: defaultPadding16),
      CustomContainerTitle('Formas de Pagamento',
        help: 'Essas são as formas de pagamento que o ${profile.name} aceita receber',
        child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: 8,
            spacing: 8,
            children: [
              ...profile
                  .paymentMethods.map((e) => SkillContainer(e)).toList(),
              if(profile.otherPayments != '')
                SkillContainer(profile.otherPayments),
            ]
        ),
      ),
    ],
  ) : const SizedBox();
}

Widget ExpertisesProfile(ProfileModel profile) {
  return checkUserType(profile.profileType) ? Column(
    children: [
      const SizedBox(height: defaultPadding16),
      CustomContainerTitle('Habilidades & Serviços',
        help: 'Essas são as habilidades e serviços que o ${profile.name} realiza pelo app',
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          runAlignment: WrapAlignment.start,
          runSpacing: 8,
          spacing: 8,
          children: profile
              .expertises.map((e) => SkillContainer(e)).toList(),
        ),
      ),
    ],
  ) : const SizedBox();
}

Widget CallButtonsProfile(ProfileModel profile, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(child: LongButton('Conversar', ContactButtonType.chat, context,
          profileParam: profile)),
      const SizedBox(width: defaultPadding16),
      Expanded(child: LongButton('Ligar', ContactButtonType.call, context,
          phoneNumber: profile.phoneNumber,
          phoneNumber2: profile.phoneNumber2)),
      const SizedBox(width: defaultPadding16),
      Expanded(child: LongButton('Compartilhar', ContactButtonType.share, context,
          profileParam: profile)),
    ],
  );
}

Widget BiographyProfile(ProfileModel profile) {
  return Column(
    children: [
      Text(profile.name,
          style: appStyle.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: defaultPadding16/2),
      if(profile.biographyDetails.isNotEmpty)
        Text(profile.biographyDetails,
          style: appStyle.bodySmall,
          textAlign: TextAlign.justify),
    ],
  );
}

Widget StatusContainer(ProfileModel profile) {
  return Container(
    decoration: BoxDecoration(
      color: appExtraLightGreyColor,
      borderRadius: defaultBorderRadius4,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      child: Row(
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
    ),
  );
}

Widget ProfileBody(ProfileModel profile, BuildContext context, {bool showCallButtons = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        const SizedBox(height: defaultPadding16/2),
        BiographyProfile(profile),
        if(showCallButtons) ...[
            const SizedBox(height: defaultPadding16),
            CallButtonsProfile(profile, context)
          ],
        ExpertisesProfile(profile),
        PaymentsMethodsProfile(profile),
        const SizedBox(height: defaultPadding16),
        AddressByProfile(profile),
        const SizedBox(height: defaultPadding16),
        SocialLinksByProfile(profile),
        const SizedBox(height: defaultPadding16),
      ],
    ),
  );
}