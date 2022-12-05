import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void onInit() {
    loaderListener(loading);

    userLogged = authServices.userLogged;
    super.onInit();
  }

  @override
  void onReady() {
    allMessagesChat.bindStream(loadInitData());
    allChats.bindStream(loadInitChatsData());
    super.onReady();
  }

  Stream<List<ChatModel>> loadInitChatsData() {
    Stream<QuerySnapshot> streamDocs = FirebaseService.getStreamListChatModelDataById(userLogged.firebaseId);

    return streamDocs.map((d) {
      List<ChatModel> listChats = [];
      for(final doc in d.docs) {
        listChats.add(ChatModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return listChats;
    });
  }

  Stream<List<MessageModel>> loadInitData() {
    print('loadInitData: ${selectedChatProfile != null} - $selectedChatProfile');
    if(selectedChatProfile != null) {
      String chatId = '${userLogged.firebaseId}_${selectedChatProfile!.firebaseId}';
      Stream<DocumentSnapshot> streamDocs = FirebaseService.getStreamChatModelData(chatId);

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

  setSelectedChatProfile(ProfileModel profile) async {
    selectedChatProfile = profile;
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
    } else if(selectedChat.toProfileId == userLogged.firebaseId) {
      selectedChat.ownerMessages.add(newMessage);
      await FirebaseService.updateChatData(selectedChat.chatId, selectedChat.updateToMessages());
    } else {
      print('sendMessage Error: ');
    }
    textMessageController.clear();
    setMessageToSent('');
//    orderMessages(selectedChat);
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