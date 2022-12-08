import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/values/enums.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import '../../../global/widgets/modal_sheet/custom_popup_widget.dart';
import '../../../global/widgets/modal_sheet/modal_bottom_sheet.dart';
import '../../../global/widgets/small/custom_containers_widget.dart';
import 'profile_widgets.dart';

class PersonalDetailsWidget extends GetView<ProfileController> {
  const PersonalDetailsWidget({
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
                    child: Stack(
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
                      backgroundColor: appBackgroundColorDark,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: appExtraLightGreyColor,
                        child: Material(
                          color: appExtraLightGreyColor,
                          borderRadius: defaultBorderRadius64,
                          child: InkWell(
                              onTap: () => showImagePicker(context, PickImageType.profile),
                              splashColor: appLightPrimaryColor,
                              borderRadius: defaultBorderRadius64,
                              child: Obx(() => CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                backgroundImage: controller.profileImage.isEmpty ? null
                                    : Image.memory(Uint8List.fromList(controller.profileImage), fit: BoxFit.cover,).image,
                                child: Visibility(
                                    visible: controller.profileImage.isEmpty,
                                    child: Icon(Icons.photo_camera,
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
                child: Visibility(
                  visible: checkUserType(controller.profileModel.profileType),
                  child: RateContainer(controller.profileModel.rate))),
              Positioned(
                right: defaultPadding16,
                bottom: 2,
                child: StatusContainer()),
            ],
          ),
        ),
        ProfileBody(controller.profileModel, context, showCallButtons: false),
      ],
    );
  }

  Widget StatusContainer() {
    return Obx(() => CustomInkWell(
      backgroundColor: appExtraLightGreyColor,
      borderRadius: defaultBorderRadius4,
      child: CustomPopupMenuWidget(
        currentValue: controller.currentStatus.value,
        options: allStatusOptions,
        onSelect: (selected) => controller.setNewCurrentStatus(selected),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
          child: Row(
            children: [
              Icon(Icons.circle,
                  size: 10,
                  color: getColorByStatus(controller.currentStatus.value)),
              const SizedBox(width: 2),
              Text(controller.currentStatus.value,
                style: appStyle.bodySmall,
              ),
              Icon(Icons.edit_rounded, color: appNormalPrimaryColor.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    ));
  }
}