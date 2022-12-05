import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/modules/edit_profile/controller/edit_controller.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_saved_model.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/values/enums.dart';
import '../../../../routes/app_pages.dart';

class ProfileController extends GetxController with LoaderMixin {
//  ProfileModel? profileParam;
//  ProfileController({this.profileParam});

  AuthServices authServices = Get.find<AuthServices>();
  RxBool loading = false.obs;

  late RxBool viewProfileSaved = false.obs;

  ProfileModel profileModel = ProfileModel();
  RxList<int> profileImage = <int>[].obs;
  RxList<int> bannerImage = <int>[].obs;
  RxString currentStatus = ''.obs;
  late RxList<ProfileSavedModel> profilesSaved = <ProfileSavedModel>[].obs;

  final ImagePicker picker = ImagePicker();
  final Rx<File?> _photo = File('').obs;
  Rx<File?> get photo => _photo;

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void onInit() {
    loaderListener(loading);

    loadProfilePage();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  loadProfilePage() {
//    if(profileParam != null) {
//      profileModel = profileParam!;
//    } else {
      profileModel = authServices.userLogged;
//    }
    profilesSaved.value = authServices.userLogged.profilesSaved;
    profileImage.value = profileModel.image;
    bannerImage.value = profileModel.banner;
    currentStatus.value = profileModel.status;
  }

  loadProfileSaved() {

  }

  gotToEditProfile() {
    EditController editController = Get.find<EditController>();
    editController.setProfileToEdit(profileModel);
    if(checkUserType(profileModel.profileType)) {
      Get.offAllNamed(Routes.editProfessional);
    } else {
      Get.offAllNamed(Routes.editClient);
    }
  }

  setNewCurrentStatus(String newStatus) async {
    currentStatus.value = newStatus;
    profileModel.status = newStatus;
    await firebase.collection(collectionProfiles)
        .doc(profileModel.firebaseId).update(profileModel.toStatus());
  }

  bool checkProfileSaved(String id) {
    viewProfileSaved.value = false;
    if(profilesSaved.isEmpty) return false;
    viewProfileSaved.value =
        profilesSaved.contains(profilesSaved.firstWhere((p) => p.firebaseId == id,
            orElse: () => ProfileSavedModel()));
    return viewProfileSaved.value;
  }

  Future addProfileToSaved(ProfileModel profile) async {
    print('profile: ${authServices.userLogged}');
    authServices.userLogged.profilesSaved.add(ProfileSavedModel.fromProfile(profile));
    await firebase.collection(collectionProfiles)
        .doc(authServices.userLogged.firebaseId).update(authServices.userLogged.toUpdateSaveds());
    viewProfileSaved.value = true;
  }

  Future removeProfileToSaved(String firebaseId) async {
    authServices.userLogged.profilesSaved.removeWhere((p) => p.firebaseId == firebaseId);
    await firebase.collection(collectionProfiles)
        .doc(authServices.userLogged.firebaseId).update(authServices.userLogged.toUpdateSaveds());
    viewProfileSaved.value = false;
  }

  Future imgFromGallery(PickImageType keyUpdate) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _photo.value = File(pickedFile.path);
      await uploadFile(keyUpdate);
    }
  }

  Future imgFromCamera(PickImageType keyUpdate) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _photo.value = File(pickedFile.path);
      uploadFile(keyUpdate);
    }
  }

  Future uploadFile(PickImageType keyUpdate) async {
    loading.value = false;
    if (_photo.value == null) return;
    loading.value = true;

    final photoSrc = await FlutterImageCompress.compressWithFile(_photo.value!.path);

    if(photoSrc != null) {
      if(keyUpdate == PickImageType.profile) {
        profileModel.image = photoSrc;
        profileImage.value = photoSrc;
      } else {
        profileModel.banner = photoSrc;
        bannerImage.value = photoSrc;
      }

      await firebase.collection(collectionProfiles)
          .doc(profileModel.firebaseId).update(keyUpdate == PickImageType.profile
          ? profileModel.toProfileImage()
          : profileModel.toBannerImage());
    } else {
      snackBar('Erro ao atualizar imagem');
    }

    loading.value = false;
  }

}