import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/buttons/custom_inkwell.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/global/widgets/textfields/text_field_widget.dart';
import 'package:delivery_servicos/app/modules/chat/controller/chat_controller.dart';
import 'package:delivery_servicos/app/modules/chat/models/chat_model.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_pages.dart';
import '../../global/constants/styles_const.dart';
import 'models/message_model.dart';

class ChatDetailsPage extends GetView<ChatController> {
  final ProfileModel profile;
  const ChatDetailsPage({
    required this.profile,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBottomMenu: false,
      showDrawerMenu: false,
      backRoute: Routes.chat,
      pageTitle: profile.name,
      body: ChatBody(context),
    );
  }

  Widget ChatBody(context) {
    return Column(
      children: [
        Obx(() => Expanded(
            child: controller.allMessagesChat.isEmpty
                ? const EmptyListWidget(message: 'Nenhuma mensagem ainda')
                : ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: controller.allMessagesChat.length,
                    itemBuilder: (context, i) {
                      return ChatMessageWidget(context,
                          controller.allMessagesChat[i],
                          (controller.allMessagesChat[i].isOwner
                              && controller.selectedChat.ownerProfileId == controller.userLogged.firebaseId)
                      || (!controller.allMessagesChat[i].isOwner
                              && controller.selectedChat.toProfileId == controller.userLogged.firebaseId));
                    })
          ),
        ),
        MessageField(context),
      ],
    );
  }

  Widget MessageField(context) {
    return Container(
      color: appLightGreyColor,
      height: 84,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: TextFieldWidget(
                backgroundColor: appExtraLightGreyColor.withOpacity(0.5),
                onChanged: (s) => controller.setMessageToSent(s),
                controller: controller.textMessageController,
                label: 'Escreva sua mensagem',
                suffixIcon: Obx(() => IconButton(
                    onPressed: controller.messageToSent.isEmpty
                        ? null : () => controller.sendMessege(),
                    icon: Icon(Icons.send_rounded,
                        color: controller.messageToSent.isEmpty
                            ? appLightGreyColor : appNormalPrimaryColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ChatMessageWidget(context, MessageModel message, bool isOwner) {
    return CustomInkWell(
      backgroundColor: Colors.transparent,
      onTap: () => globalAlertDialog(
        title: message.message,
        labelActionButton: 'ok',
        text: message.dateSent,
        onPressedAction: () => Get.back()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isOwner
              ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: isOwner
                  ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: defaultCircularRadius16,
                      topLeft: defaultCircularRadius16,
                      bottomLeft: isOwner ? defaultCircularRadius16 : Radius.zero,
                      bottomRight: isOwner ? Radius.zero : defaultCircularRadius16,
                    ),
                    color: !isOwner ? appLightPrimaryColor.withOpacity(0.25) : appExtraLightGreyColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 90, maxWidth: Get.width * 0.8),
                      child: Text('${message.message}')),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: defaultCircularRadius8,
                      bottomRight: defaultCircularRadius8,
                    ),
                    color: !isOwner ? appLightPrimaryColor.withOpacity(0.25) : appExtraLightGreyColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                    child: Text('à ${dateTimeAt(message.dateSent, levelOfPrecision: 0)}',
                        style: appStyle.bodySmall?.copyWith(
                            color: !isOwner ? appNormalGreyColor : appNormalGreyColor.withOpacity(0.75))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
