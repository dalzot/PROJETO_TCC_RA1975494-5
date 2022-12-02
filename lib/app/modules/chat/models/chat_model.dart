import 'dart:convert';

class ChatModel {
  String firebaseId,
      name,
      phoneNumber;
  List<int> image;

  ChatModel({
    this.firebaseId = '',
    this.image = const [],
    this.name = '',
    this.phoneNumber = ''});

  factory ChatModel.fromJson(Map<String, dynamic> json)=> ChatModel(
    firebaseId: json['firebaseId'],
    image: base64Decode(json['image']),
    name: json['name'],
    phoneNumber: json['phoneNumber'],
  );

  static List<ChatModel> fromList(List<dynamic> l) {
    return List<ChatModel>.from(l.map((model)=> ChatModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<ChatModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    "firebaseId": firebaseId,
    "name": name,
    "image": base64Encode(image),
  };

  @override
  String toString() {
    return 'ChatModel($firebaseId, $name)';
  }
}