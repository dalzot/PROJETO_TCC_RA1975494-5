import 'dart:convert';

import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';

class ProfileSavedModel {
  String firebaseId,
      name,
      phoneNumber;
  List<int> image;

  ProfileSavedModel({
    this.firebaseId = '',
    this.image = const [],
    this.name = '',
    this.phoneNumber = ''});

  factory ProfileSavedModel.fromJson(Map<String, dynamic> json)=> ProfileSavedModel(
    firebaseId: json['firebaseId'],
    image: json['image'] is List ? List<int>.from(json['image']) : base64Decode(json['image']),
    name: json['name'],
    phoneNumber: json['phoneNumber'],
  );

  factory ProfileSavedModel.fromProfile(ProfileModel profile)=> ProfileSavedModel(
    firebaseId: profile.firebaseId,
    image: profile.image,
    name: profile.name,
    phoneNumber: profile.phoneNumber,
  );

  static List<ProfileSavedModel> fromList(List<dynamic> l) {
    return List<ProfileSavedModel>.from(l.map((model)=> ProfileSavedModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<ProfileSavedModel> l) {
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
    return 'ProfileSavedModel($firebaseId, $name)';
  }
}