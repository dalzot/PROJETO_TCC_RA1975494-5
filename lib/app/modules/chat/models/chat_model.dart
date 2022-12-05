import 'dart:convert';

import 'package:delivery_servicos/app/modules/chat/models/message_model.dart';

class ChatModel {
  String chatId,
      toMessagingId,
      toProfileId,
      toName,
      ownerMessagingId,
      ownerProfileId,
      ownerName;
  List<int> toImage,
      ownerImage;
  List<MessageModel> toMessages,
      ownerMessages;

  ChatModel({
    this.chatId = '',
    this.toMessagingId = '',
    this.toProfileId = '',
    this.toName = '',
    this.ownerMessagingId = '',
    this.ownerProfileId = '',
    this.ownerName = '',
    this.toImage = const [],
    this.ownerImage = const [],
    this.toMessages = const [],
    this.ownerMessages = const [],
  });

  factory ChatModel.fromJson(Map<String, dynamic> json)=> ChatModel(
    chatId: json['chatId'],
    toMessagingId: json['toMessagingId'],
    toProfileId: json['toProfileId'],
    toName: json['toName'],
    ownerMessagingId: json['ownerMessagingId'],
    ownerProfileId: json['ownerProfileId'],
    ownerName: json['ownerName'],
    toImage: base64Decode(json['toImage']),
    ownerImage: base64Decode(json['ownerImage']),
    toMessages: MessageModel.fromList(json['toMessages'] ?? []),
    ownerMessages: MessageModel.fromList(json['ownerMessages'] ?? []),
  );

  static List<ChatModel> fromList(List<dynamic> l) {
    return List<ChatModel>.from(l.map((model)=> ChatModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<ChatModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    "chatId": chatId,
    "toMessagingId": toMessagingId,
    "toProfileId": toProfileId,
    "toName": toName,
    "ownerMessagingId": ownerMessagingId,
    "ownerProfileId": ownerProfileId,
    "ownerName": ownerName,
    "toImage": base64Encode(toImage),
    "ownerImage": base64Encode(ownerImage),
    "toMessages": MessageModel.fromList(toMessages),
    "ownerMessages": MessageModel.fromList(ownerMessages),
  };

  Map<String, dynamic> updateOwnerMessages() => {
    "ownerMessages": MessageModel.toList(ownerMessages),
  };

  Map<String, dynamic> updateToMessages() => {
    "toMessages": MessageModel.toList(toMessages),
  };

  @override
  String toString() {
    return 'ChatModel($chatId, owner: $ownerName, to: $toName)';
  }
}