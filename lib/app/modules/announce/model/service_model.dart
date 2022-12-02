import 'package:delivery_servicos/core/util/global_functions.dart';

import 'proposal_model.dart';

class ServiceModel {
  String?
      serviceId,
      clientId,
      clientMessagingId,
      professionalId,
      cep,
      district,
      complement,
      province,
      city,
      street,
      number,
      observations,
      clientName,
      phone1,
      phone2,
      whatsapp,
      dateMin,
      dateMax,
      dateCreated,
      dateUpdated,
      dateApproved,
      status,
      minPrice,
      maxPrice;
  List<String>?
      serviceExpertise,
      servicePayment;
  List<ProposalModel>? proposals;

  ServiceModel({
    this.serviceId,
    this.clientId,
    this.clientMessagingId,
    this.professionalId,
    this.cep,
    this.district,
    this.complement,
    this.province,
    this.city,
    this.street,
    this.number,
    this.observations,
    this.clientName,
    this.phone1,
    this.phone2,
    this.whatsapp,
    this.minPrice,
    this.maxPrice,
    this.dateMin,
    this.dateMax,
    this.serviceExpertise,
    this.servicePayment,
    this.dateCreated,
    this.dateUpdated,
    this.dateApproved,
    this.status,
    this.proposals,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json)=> ServiceModel(
    serviceId: json['serviceId'],
    clientId: json['clientId'],
    clientMessagingId: json['clientMessagingId'],
    professionalId: json['professionalId'],
    cep: getMaskedZipCode(json['cep']),
    district: json['district'],
    complement: json['complement'],
    province: json['province'],
    city: json['city'],
    street: json['street'],
    number: json['number'],
    observations: json['observations'],
    clientName: json['clientName'],
    phone1: getMaskedPhoneNumber(json['phone1']),
    phone2: getMaskedPhoneNumber(json['phone2']),
    whatsapp: getMaskedPhoneNumber(json['whatsapp']),
    minPrice: json['minPrice'],
    maxPrice: json['maxPrice'],
    dateMin: json['dateMin'],
    dateMax: json['dateMax'],
    serviceExpertise: List<String>.from(json['serviceExpertise']),
    servicePayment: List<String>.from(json['servicePayment']),
    dateCreated: json['dateCreated'],
    dateUpdated: json['dateUpdated'],
    dateApproved: json['dateApproved'],
    status: json['status'],
    proposals: ProposalModel.fromList(json['proposals']),
  );

  static List<ServiceModel> fromList(List<dynamic> l) {
    return List<ServiceModel>.from(l.map((model)=> ServiceModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<ServiceModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'clientId': clientId,
    'clientMessagingId': clientMessagingId,
    'professionalId': professionalId,
    'cep': cep,
    'district': district,
    'complement': complement,
    'province': province,
    'city': city,
    'street': street,
    'number': number,
    'observations': observations,
    'clientName': clientName,
    'phone1': phone1,
    'phone2': phone2,
    'whatsapp': whatsapp,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'dateMin': dateMin,
    'dateMax': dateMax,
    'serviceExpertise': serviceExpertise,
    'servicePayment': servicePayment,
    'dateCreated': dateCreated,
    'dateUpdated': dateUpdated,
    'dateApproved': dateApproved,
    'status': status, // aberto | concluído
    'proposals': ProposalModel.toList(proposals!),
  };

  Map<String, dynamic> toProposal() => {
    'proposals': ProposalModel.toList(proposals!),
  };

  @override
  String toString() {
    return 'ServiceModel($serviceId, $clientName)';
  }
}