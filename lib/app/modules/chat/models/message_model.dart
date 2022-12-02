import 'dart:convert';

import 'package:delivery_servicos/core/util/global_functions.dart';

class MessageModel {
  String firebaseId,
      name,
      phoneNumber;
  List<int> image;

  MessageModel({
    this.firebaseId = '',
    this.image = const [],
    this.name = '',
    this.phoneNumber = ''});

  factory MessageModel.fromJson(Map<String, dynamic> json)=> MessageModel(
    firebaseId: json['firebaseId'],
    image: base64Decode(json['image']),
    name: json['name'],
    phoneNumber: json['phoneNumber'],
  );

  static List<MessageModel> fromList(List<dynamic> l) {
    return List<MessageModel>.from(l.map((model)=> MessageModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<MessageModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    "firebaseId": firebaseId,
    "name": name,
    "image": base64Encode(image),
    "phoneNumber": getRawPhoneNumber(phoneNumber),
  };

  @override
  String toString() {
    return 'MessageModel($firebaseId, $name)';
  }
}