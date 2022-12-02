import 'package:delivery_servicos/app/modules/chat/models/chat_model.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:get/get.dart';


class ChatController extends GetxController with LoaderMixin {
  final String? selectedChatProfileId;
  ChatController({this.selectedChatProfileId});

  AuthServices authServices = Get.find<AuthServices>();
  RxBool loading = false.obs;

  ChatModel selectedChat = ChatModel();

  @override
  void onInit() {
    loaderListener(loading);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}