import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/chat/controller/chat_controller.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

class ChatDetailsPage extends GetView<ChatController> {
  const ChatDetailsPage({
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScaffold(
          pageTitle: controller.selectedChat.name,
          body: EmptyListWidget()),
    );
  }
}
