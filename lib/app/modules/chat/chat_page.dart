import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/chat/controller/chat_controller.dart';
import 'package:delivery_servicos/app/modules/chat/models/chat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/util/global_functions.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/buttons/custom_inkwell.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageTitle: 'Conversas',
      body: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          controller.allChats.isEmpty
              ? const EmptyListWidget(message: 'Não encontramos nenhuma conversa')
              : Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.allChats.length,
                itemBuilder: (context, i) {
                  return ChatMessageWidget(context, controller.allChats[i]);
                }),
              )
        ],
      )),
    );
  }

  Widget ChatMessageWidget(context, ChatModel chat) {
    return CustomInkWell(
      backgroundColor: Colors.transparent,
      onTap: () async {
        await globalFunctionOpenChat(profileId: chat.toProfileId);
      },
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
                    image: chat.toImage.isEmpty ? null : DecorationImage(
                        image: Image.memory(Uint8List.fromList(chat.toImage)).image,
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(defaultCircularRadius64),
                    color: appExtraLightGreyColor.withOpacity(0.5)
                ),
                child: Visibility(
                  visible: chat.toImage.isEmpty,
                  child: Icon(Icons.image_not_supported, color: appLightGreyColor,),
                ),
              ),
              const SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.toName,
                        style: appStyle.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
//                    const SizedBox(height: 4,),
//                    Text(getMaskedPhoneNumber(profile.phoneNumber),
//                        style: appStyle.bodySmall?.copyWith(
//                            fontWeight: FontWeight.w500,
//                            color: appNormalGreyColor),
//                        softWrap: true,
//                        overflow: TextOverflow.ellipsis,
//                        maxLines: 1),
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
