class ProposalModel {
  String?
      professionalId,
      professionalName,
      professionalMessagingId,
      observations,
      phone1,
      dateCreated,
      dateUpdated,
      reasonRecuse,
      status, // aprovada | recusada
      price;

  ProposalModel({
    this.professionalId,
    this.professionalName,
    this.professionalMessagingId,
    this.observations,
    this.phone1,
    this.dateCreated,
    this.dateUpdated,
    this.reasonRecuse,
    this.status,
    this.price,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json)=> ProposalModel(
    professionalId: json['professionalId'],
    professionalName: json['professionalName'],
    professionalMessagingId: json['professionalMessagingId'],
    observations: json['observations'],
    phone1: json['phone1'],
    dateCreated: json['dateCreated'],
    dateUpdated: json['dateUpdated'],
    status: json['status'],
    reasonRecuse: json['reasonRecuse'],
    price: json['price'],
  );

  static List<ProposalModel> fromList(List<dynamic> l) {
    return List<ProposalModel>.from(l.map((model)=> ProposalModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<ProposalModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    'professionalId': professionalId,
    'professionalName': professionalName,
    'professionalMessagingId': professionalMessagingId,
    'observations': observations,
    'phone1': phone1,
    'dateCreated': dateCreated,
    'dateUpdated': dateUpdated,
    'status': status,
    'reasonRecuse': reasonRecuse,
    'price': price,
  };

  @override
  String toString() {
    return 'ProposalModel($professionalId, $professionalName, $professionalMessagingId)';
  }
}