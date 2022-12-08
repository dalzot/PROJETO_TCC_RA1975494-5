import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/global/notification/custom_local_notification.dart';
import 'package:delivery_servicos/app/modules/chat/models/chat_model.dart';
import 'package:delivery_servicos/app/modules/chat/models/message_model.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class ChatController extends GetxController with LoaderMixin {
  AuthServices authServices = Get.find<AuthServices>();
  late ProfileModel userLogged;
  ProfileModel? selectedChatProfile;
  RxBool loading = false.obs;

  RxString messageToSent = ''.obs;
  final textMessageController = TextEditingController();
  final allMessagesChat = <MessageModel>[].obs;

  final allChats = <ChatModel>[].obs;
  ChatModel selectedChat = ChatModel();
  String? selectedChatId;

  @override
  void onInit() {
    userLogged = authServices.userLogged;
    super.onInit();
  }

  @override
  void onReady() {
    loading.value = true;
    allMessagesChat.bindStream(loadInitData());
    allChats.bindStream(loadInitChatsData());
    loading.value = false;
    super.onReady();
  }

  Stream<List<ChatModel>> loadInitChatsData() {
    loading.value = true;
    Stream<QuerySnapshot> streamOwner = FirebaseService.getStreamListChatModelDataByIdOwner(userLogged.firebaseId);
    Stream<QuerySnapshot> streamReceiver = FirebaseService.getStreamListChatModelDataByIdReceiver(userLogged.firebaseId);

    return streamOwner.map((d) {
        List<ChatModel> listChats = [];
        for(final doc in d.docs) {
          listChats.add(ChatModel.fromJson(doc.data() as Map<String, dynamic>));
        }
        streamReceiver.forEach((d) {
          for(final doc in d.docs) {
            listChats.add(ChatModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        });

        print('listChats.length: ${listChats.length}');
        loading.value = false;
        return listChats;
      });
  }

  Stream<List<MessageModel>> loadInitData() {
    if(selectedChatProfile != null) {
      String chatId = selectedChatId ?? '${userLogged.firebaseId}_${selectedChatProfile!.firebaseId}';
      Stream<DocumentSnapshot> streamDocs = FirebaseService.getStreamChatModelData(chatId);

      print('chatId: $chatId - $selectedChatId');

      return streamDocs.map((d) {
        if(d.exists) {
          ChatModel currentChat = ChatModel.fromJson(d.data() as Map<String, dynamic>);
          selectedChat = currentChat;
        } else {
          ChatModel createdChat = ChatModel(
            chatId: chatId,
            ownerImage: userLogged.image,
            ownerMessagingId: userLogged.firebaseMessagingId,
            ownerName: userLogged.name,
            ownerProfileId: userLogged.firebaseId,
            ownerMessages: [],
            toImage: selectedChatProfile!.image,
            toMessagingId: selectedChatProfile!.firebaseMessagingId,
            toName: selectedChatProfile!.name,
            toProfileId: selectedChatProfile!.firebaseId,
            toMessages: [],
          );
          FirebaseService.setChatData(chatId, createdChat.toJson());
          selectedChat = createdChat;
        }
        return orderMessages(selectedChat).toList();
      });
    } else {
      return Stream.empty();
    }
  }

  setSelectedChatProfile(ProfileModel profile, String? chatId) async {
    selectedChatProfile = profile;
    selectedChatId = chatId;
    allMessagesChat.bindStream(loadInitData());
  }

  setMessageToSent(s) {
    messageToSent.value = s;
  }

  sendMessege() async {
    MessageModel newMessage = MessageModel(
      message: textMessageController.text.trim(),
      dateSent: dateNowString(),
      isOwner: selectedChat.ownerProfileId == userLogged.firebaseId
    );
    if(selectedChat.ownerProfileId == userLogged.firebaseId) {
      selectedChat.ownerMessages.add(newMessage);
      await FirebaseService.updateChatData(selectedChat.chatId, selectedChat.updateOwnerMessages());
      CustomLocalNotification().sendPrivateMessaging('Nova mensagem recebida',
          '${selectedChat.ownerName}: ${textMessageController.text.trim()}',
          selectedChat.chatId,
          selectedChat.toMessagingId);
    } else if(selectedChat.toProfileId == userLogged.firebaseId) {
      selectedChat.toMessages.add(newMessage);
      await FirebaseService.updateChatData(selectedChat.chatId, selectedChat.updateToMessages());
      CustomLocalNotification().sendPrivateMessaging('Nova mensagem recebida',
          '${selectedChat.toName}: ${textMessageController.text.trim()}',
          selectedChat.chatId,
          selectedChat.ownerMessagingId);
    } else {
      print('sendMessage Error: ');
    }
    textMessageController.clear();
    setMessageToSent('');
  }

  List<MessageModel> orderMessages(ChatModel chat) {
    List<MessageModel> messages = [];
    messages.addAll(chat.ownerMessages);
    messages.addAll(chat.toMessages);

    print('${messages.length} - toLength: ${chat.toMessages.length} - ownerLength: ${chat.ownerMessages.length}');

    messages.sort((a,b) => dateTimeFromString(a.dateSent).compareTo(dateTimeFromString(b.dateSent)));
    return messages.reversed.toList();
  }

  checkIfOwner() => userLogged.firebaseId == selectedChat.ownerProfileId;

  @override
  void onClose() {

    super.onClose();
  }
}