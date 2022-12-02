import 'dart:convert';
import 'package:delivery_servicos/app/modules/profile/models/profile_saved_model.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';

class ProfileModel {
  String
      firebaseId,
      name,
      docCpf,
      docRg,
      docRgEmit,
      dateBirthday,
      phoneNumber,
      phoneNumber2,
      otherPayments,
      biographyDetails,
      email,
      password,
      facebook,
      instagram,
      linkedin,
      telegram,
      whatsapp,
      addressStreet,
      addressNumber,
      addressComplement,
      addressCity,
      addressProvince,
      addressDistrict,
      addressCEP,
      addressLatGPS,
      addressLngGPS,
      profileType, // 0: Cliente | 1: Profissional | 2: Admin
      status,     // 0: Offline | 1: Ocupado | 2: Online
      dateCreated,
      dateUpdated,
      dateLastView,
      firebaseMessagingId;
  bool showFullName,
      showFullAddress;
  double rate,
      totalRequests;
  int qtdRequests,
      level;
  List<String> expertises;
  List<String> paymentMethods;
  List<String> serviceProposals;
  List<ProfileSavedModel> profilesSaved;
  List<int> image,
      banner;

  ProfileModel({
    this.firebaseId = '',
    this.image = const [],
    this.banner = const [],
    this.name = '',
    this.docCpf = '',
    this.docRg = '',
    this.docRgEmit = '',
    this.dateBirthday = '',
    this.phoneNumber = '',
    this.phoneNumber2 = '',
    this.otherPayments = '',
    this.biographyDetails = '',
    this.paymentMethods = const [],
    this.email = '',
    this.password = '',
    this.facebook = '',
    this.instagram = '',
    this.linkedin = '',
    this.telegram = '',
    this.whatsapp = '',
    this.addressStreet = '',
    this.addressNumber = '',
    this.addressComplement = '',
    this.addressCity = '',
    this.addressProvince = '',
    this.addressDistrict = '',
    this.addressCEP = '',
    this.addressLatGPS = '',
    this.addressLngGPS = '',
    this.profileType = '',
    this.status = '',
    this.showFullName = false,
    this.showFullAddress = false,
    this.profilesSaved = const [],
    this.totalRequests = 0.0,
    this.qtdRequests = 0,
    this.rate = 0.0,
    this.level = 0,
    this.expertises = const [],
    this.dateCreated = '',
    this.dateUpdated = '',
    this.dateLastView = '',
    this.firebaseMessagingId = '',
    this.serviceProposals = const [],
  });

  updateProfile(ProfileModel profile) {
    phoneNumber = profile.phoneNumber;
    phoneNumber2 = profile.phoneNumber2;
    otherPayments = profile.otherPayments;
    biographyDetails = profile.biographyDetails;
    paymentMethods = profile.paymentMethods;
    facebook = profile.facebook;
    instagram = profile.instagram;
    linkedin = profile.linkedin;
    telegram = profile.telegram;
    whatsapp = profile.whatsapp;
    addressStreet = profile.addressStreet;
    addressNumber = profile.addressNumber;
    addressComplement = profile.addressComplement;
    addressCity = profile.addressCity;
    addressProvince = profile.addressProvince;
    addressDistrict = profile.addressDistrict;
    addressCEP = profile.addressCEP;
    addressLatGPS = profile.addressLatGPS;
    addressLngGPS = profile.addressLngGPS;
    expertises = profile.expertises;
    firebaseMessagingId = profile.firebaseMessagingId;
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    firebaseId: json['firebaseId'],
    image: false ? List<int>.from(json['image']) : base64Decode(json['image']),
    banner: false ? List<int>.from(json['banner']) : base64Decode(json['banner']),
    name: json['name'],
    docCpf: getMaskedDocCPF(json['docCpf']),
    docRg: getMaskedDocRG(json['docRg']),
    docRgEmit: json['docRgEmit'],
    dateBirthday: json['dateBirthday'],
    phoneNumber: json['phoneNumber'],
    phoneNumber2: json['phoneNumber2'],
    email: json['email'],
    otherPayments: json['otherPayments'],
    biographyDetails: json['biographyDetails'],
    paymentMethods: json['paymentMethods'] != null
        ? List<String>.from(json['paymentMethods']) : [],
    password: json['password'],
    facebook: json['facebook'],
    instagram: json['instagram'],
    linkedin: json['linkedin'],
    telegram: json['telegram'],
    whatsapp: json['whatsapp'],
    addressStreet: json['addressStreet'],
    addressNumber: json['addressNumber'],
    addressComplement: json['addressComplement'],
    addressCity: json['addressCity'],
    addressProvince: json['addressProvince'],
    addressDistrict: json['addressDistrict'],
    addressCEP: json['addressCEP'],
    addressLatGPS: json['addressLatGPS'],
    addressLngGPS: json['addressLngGPS'],
    profileType: json['profileType'],
    status: json['status'],
    showFullName: json['showFullName'],
    showFullAddress: json['showFullAddress'],
    expertises: json['expertises'] != null
        ? List<String>.from(json['expertises']) : [],
    rate: double.parse(json['rate'].toString()),
    totalRequests: double.parse(json['totalRequests'].toString()),
    qtdRequests: json['qtdRequests'],
    profilesSaved: json['profilesSaved'] != null
        ? ProfileSavedModel.fromList(json['profilesSaved']) : [],
    dateCreated: json['dateCreated'],
    dateUpdated: json['dateUpdated'],
    dateLastView: json['dateLastView'],
    level: json['level'],
    firebaseMessagingId: json['firebaseMessagingId'] ?? '',
    serviceProposals: List<String>.from(json['serviceProposals'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    "firebaseId": firebaseId,
    "name": name,
    "image": base64Encode(image),
    "banner": base64Encode(banner),
    "docCpf": getRawZipCode(docCpf),
    "docRg": getRawZipCode(docRg),
    "docRgEmit": docRgEmit,
    "dateBirthday": dateBirthday,
    "phoneNumber": getRawPhoneNumber(phoneNumber),
    "phoneNumber2": getRawPhoneNumber(phoneNumber2),
    "email": email,
    "otherPayments": otherPayments,
    "biographyDetails": biographyDetails,
    "paymentMethods": paymentMethods,
    "password": password,
    "facebook": facebook,
    "instagram": instagram,
    "linkedin": linkedin,
    "telegram": telegram,
    "whatsapp": getRawPhoneNumber(whatsapp),
    "addressStreet": addressStreet,
    "addressNumber": addressNumber,
    "addressComplement": addressComplement,
    "addressCity": addressCity,
    "addressProvince": addressProvince,
    "addressDistrict": addressDistrict,
    "addressCEP": getRawZipCode(addressCEP),
    "addressLatGPS": addressLatGPS,
    "addressLngGPS": addressLngGPS,
    "profileType": profileType,
    "status": status,
    "showFullName": showFullName,
    "showFullAddress": showFullAddress,
    "expertises": expertises,
    "rate": rate,
    "totalRequests": totalRequests,
    "qtdRequests": qtdRequests,
    "profilesSaved": ProfileSavedModel.toList(profilesSaved),
    "dateCreated": dateCreated,
    "dateUpdated": dateUpdated,
    "dateLastView": dateLastView,
    "level": level,
    "firebaseMessagingId": firebaseMessagingId,
  };

  Map<String, dynamic> toEditJson() => {
    "phoneNumber": getRawPhoneNumber(phoneNumber),
    "phoneNumber2": getRawPhoneNumber(phoneNumber2),
    "otherPayments": otherPayments,
    "biographyDetails": biographyDetails,
    "paymentMethods": paymentMethods,
    "facebook": facebook,
    "instagram": instagram,
    "linkedin": linkedin,
    "telegram": telegram,
    "whatsapp": getRawPhoneNumber(whatsapp),
    "addressStreet": addressStreet,
    "addressNumber": addressNumber,
    "addressComplement": addressComplement,
    "addressCity": addressCity,
    "addressProvince": addressProvince,
    "addressDistrict": addressDistrict,
    "addressCEP": getRawZipCode(addressCEP),
    "addressLatGPS": addressLatGPS,
    "addressLngGPS": addressLngGPS,
    "expertises": expertises,
    "dateUpdated": dateUpdated,
  };

  Map<String, dynamic> toUpdateSaveds() => {
    "profilesSaved": ProfileSavedModel.toList(profilesSaved),
  };

  Map<String, dynamic> toProfileImage() => {
    "image": base64Encode(image),
  };

  Map<String, dynamic> toBannerImage() => {
    "banner": base64Encode(banner),
  };

  Map<String, dynamic> toStatus() => {
    "status": status,
  };

  Map<String, dynamic> toFirebaseToken() => {
    "firebaseMessagingId": firebaseMessagingId,
  };

  Map<String, dynamic> toProposals() => {
    "serviceProposals": serviceProposals,
  };

  @override
  String toString() {
    return 'ProfileModel($firebaseId, $name, $email, $profileType, $status)';
  }
}