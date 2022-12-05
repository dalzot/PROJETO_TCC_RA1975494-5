class MessageModel {
  String message, dateSent;
  bool isOwner;

  MessageModel({
    this.message = '',
    this.dateSent = '',
    this.isOwner = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json)=> MessageModel(
    message: json['message'] ?? '',
    dateSent: json['dateSent'] ?? '',
    isOwner: json['isOwner'] ?? false,
  );

  static List<MessageModel> fromList(List<dynamic> l) {
    return List<MessageModel>.from(l.map((model)=> MessageModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<MessageModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "dateSent": dateSent,
    "isOwner": isOwner,
  };

  @override
  String toString() {
    return 'MessageModel($message, $dateSent, $isOwner)';
  }
}