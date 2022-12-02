import 'dart:convert';

import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/constants/styles_const.dart';
import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/core/util/global_launch_url.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import '../../../../core/values/enums.dart';
import '../../../../core/util/open_social_links.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import '../../../global/widgets/modal_sheet/custom_popup_widget.dart';
import '../../../global/widgets/modal_sheet/modal_bottom_sheet.dart';
import '../../../global/widgets/small/custom_containers_widget.dart';
import '../models/profile_model.dart';

class PersonalDetailsWidget extends GetView<ProfileController> {
  final ProfileModel? profileView;
  const PersonalDetailsWidget({
    this.profileView,
    Key? key}) : super(key: key);

  void showImagePicker(BuildContext context, PickImageType type) {
    openModalBottomSheet(context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            componentButtonPicker(
                label: 'Câmera',
                iconType: Icons.photo_camera_outlined,
                onTap: () {
                  controller.imgFromCamera(type);
                  Navigator.of(context).pop();
                }),
            componentButtonPicker(
                label: 'Galeria',
                iconType: Icons.image_outlined,
                onTap: () {
                  controller.imgFromGallery(type);
                  Navigator.of(context).pop();
                }),
          ],
        ),
        title: "Escolha uma das opções",
        textButton: "CANCELAR");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 164,
          child: Stack(
            children: [
              Obx(() => InkWell(
                onTap: controller.bannerImage.isEmpty
                  ? null : () => showDialog(
                    context: context,
                    builder: (bContext) => Scaffold(
                      appBar: AppBar(
                        title: Text('Image ampliada'),
                        centerTitle: true,
                      ),
                      body: SingleChildScrollView(
                        child: Image.memory(Uint8List.fromList(controller.bannerImage),
                            fit: BoxFit.fitWidth),
                      ),
                    )),
                child: Container(
                    width: Get.width,
                    height: 148,
                    decoration: BoxDecoration(
                      color: appLightGreyColor,
                      image: controller.bannerImage.isEmpty ? null
                          : DecorationImage(image: Image.memory(Uint8List.fromList(controller.bannerImage)).image,
                          fit: BoxFit.fitWidth
                      ),
                    ),
                    child: profileView != null ? null : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              icon: Icon(Icons.photo_camera,
                                  color: controller.bannerImage.isEmpty
                                      ? appExtraLightGreyColor : appExtraLightGreyColor.withOpacity(0.5)),
                              onPressed: () => showImagePicker(context, PickImageType.banner)),
                        ),
                      ],
                    ),
                  ),
              )),
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
                          child: InkWell(
                              onTap: profileView != null ? null : () => showImagePicker(context, PickImageType.profile),
                              splashColor: appLightPrimaryColor,
                              borderRadius: defaultBorderRadius64,
                              child: Obx(() => CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                backgroundImage: controller.profileImage.isEmpty ? null
                                    : Image.memory(Uint8List.fromList(controller.profileImage), fit: BoxFit.cover,).image,
                                child: Visibility(
                                    visible: controller.profileImage.isEmpty,
                                    child: Icon(profileView != null
                                        ? Icons.image_not_supported : Icons.photo_camera,
                                        color: appLightGreyColor)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: defaultPadding16,
                bottom: 2,
                child: RateContainer(controller.profileModel.rate)),
              Positioned(
                right: defaultPadding16,
                bottom: 2,
                child: StatusContainer()),
            ],
          ),
        ),
        ProfileBody(context),
      ],
    );
  }

  Widget ProfileBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: defaultPadding16/2),
          Text(controller.profileModel.name,
              style: appStyle.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Visibility(
            visible: controller.profileModel.biographyDetails != '',
            child: Column(
              children: [
                const SizedBox(height: defaultPadding16/2),
                Text(controller.profileModel.biographyDetails,
                    style: appStyle.bodySmall,
                    textAlign: TextAlign.justify),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: LongButton('Conversar', ContactButtonType.chat, context)),
              const SizedBox(width: defaultPadding16),
              Expanded(child: LongButton('Ligar', ContactButtonType.call, context,
                  phoneNumber: controller.profileModel.phoneNumber,
                  phoneNumber2: controller.profileModel.phoneNumber2)),
              const SizedBox(width: defaultPadding16),
              Expanded(child: LongButton('Compartilhar', ContactButtonType.share, context)),
            ],
          ),
          Visibility(
            visible: checkUserType(controller.profileModel.profileType),
            child: Column(
              children: [
                const SizedBox(height: defaultPadding16),
                CustomContainerTitle('Habilidades & Serviços',
                  help: 'Essas são as habilidades e serviços que o ${controller.profileModel.name} realiza pelo app',
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    runSpacing: 8,
                    spacing: 8,
                    children: controller.profileModel
                        .expertises.map((e) => SkillContainer(e)).toList(),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: checkUserType(controller.profileModel.profileType),
            child: Column(
              children: [
                const SizedBox(height: defaultPadding16),
                CustomContainerTitle('Formas de Pagamento',
                  help: 'Essas são as formas de pagamento que o ${controller.profileModel.name} aceita receber',
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        ...controller.profileModel
                            .paymentMethods.map((e) => SkillContainer(e)).toList(),
                        if(controller.profileModel.otherPayments != '')
                          SkillContainer(controller.profileModel.otherPayments),
                      ]
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding16),
          CustomContainerTitle('Endereço',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cidade: ', style: appStyle.bodyMedium),
                    Expanded(
                      child: Text('${controller.profileModel.addressCity} - ${controller.profileModel.addressProvince} '
                          '(${getMaskedZipCode(controller.profileModel.addressCEP)})',
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
                      child: Text('${controller.profileModel.addressStreet}',
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
                      child: Text('${controller.profileModel.addressDistrict}, nº ${controller.profileModel.addressNumber}',
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                Visibility(
                  visible: controller.profileModel.addressComplement.toString().trim() != '',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Complemento: '),
                        Text(controller.profileModel.addressComplement.toString()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                OpenAddressOnMap(controller.profileModel),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding16),
          CustomContainerTitle('Redes Sociais',
              help: 'Essas são as redes sociais do ${controller.profileModel.name}, '
                  'você pode segui-lo para acompanhar de perto seus serviços',
              child: Column(
                children: [
                  Visibility(
                    visible: controller.profileModel.whatsapp != '',
                    child: Column(
                      children: [
                        IconButtonSocial(controller.profileModel.whatsapp, SocialButtonType.whatsapp),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.profileModel.instagram != '',
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding8),
                        IconButtonSocial(controller.profileModel.instagram, SocialButtonType.instagram),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.profileModel.facebook != '',
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding8),
                        IconButtonSocial(controller.profileModel.facebook, SocialButtonType.facebook),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.profileModel.linkedin != '',
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding8),
                        IconButtonSocial(controller.profileModel.linkedin, SocialButtonType.linkedin),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.profileModel.telegram != '',
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding8),
                        IconButtonSocial(controller.profileModel.telegram, SocialButtonType.telegram),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: getVisibilityByLinks(),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Nenhuma rede social adicionada'),
                      ),
                    ),
                  ),
                ],
              )
          ),
          const SizedBox(height: defaultPadding16),
        ],
      ),
    );
  }

  Widget StatusContainer() {
    return Obx(() {
      Widget rowStatus = Padding(
        padding: EdgeInsets.symmetric(vertical: profileView != null ? 6.0 : 2.0, horizontal: 6.0),
        child: Row(
          children: [
            Icon(Icons.circle,
                size: 10,
                color: getColorByStatus(controller.currentStatus.value)),
            const SizedBox(width: 2),
            Text(controller.currentStatus.value,
              style: appStyle.bodySmall,
            ),
            if(profileView == null)
              Icon(Icons.edit_rounded, color: appNormalPrimaryColor.withOpacity(0.5)),
          ],
        ),
      );
      if(profileView == null) {
        return CustomInkWell(
          backgroundColor: appExtraLightGreyColor,
          borderRadius: defaultBorderRadius4,
          child: CustomPopupMenuWidget(
            currentValue: controller.currentStatus.value,
            options: allStatusOptions,
            onSelect: (selected) => controller.setNewCurrentStatus(selected),
            child: rowStatus,
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            color: appExtraLightGreyColor,
            borderRadius: defaultBorderRadius4,
          ),
          child: rowStatus,
        );
      }
    });
  }

  Widget IconButtonSocial(String social, SocialButtonType type) {
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
              OpenSocialLink().sendWhatsMessage(controller.profileModel.whatsapp);
              break;
            case SocialButtonType.telegram:
              OpenSocialLink().sendTelegramMessage(controller.profileModel.telegram);
              break;
            case SocialButtonType.instagram:
              OpenSocialLink().sendInstagram(controller.profileModel.instagram);
              break;
            case SocialButtonType.linkedin:
              OpenSocialLink().sendLinkedin(controller.profileModel.linkedin);
              break;
            case SocialButtonType.facebook:
              OpenSocialLink().sendFacebook(controller.profileModel.facebook);
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
                    ? '+55 ${getMaskedPhoneNumber(controller.profileModel.whatsapp)}'
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

  bool getVisibilityByLinks() {
    return controller.profileModel.facebook == '' &&
        controller.profileModel.linkedin == '' &&
        controller.profileModel.instagram == '' &&
        controller.profileModel.telegram == '' &&
        controller.profileModel.whatsapp == '';
  }
}