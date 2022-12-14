import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/modules/announce/model/service_model.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:search_cep/search_cep.dart';

import '../../../../core/util/global_functions.dart';
import '../../../../core/util/print_exception.dart';

class HomeClientController extends GetxController {
  AuthServices authServices = Get.find<AuthServices>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool loading = false.obs;

  RxList<ProfileModel> filteredProfessionals = <ProfileModel>[].obs;
  RxList<ProfileModel> filteredProfessionalsAds = <ProfileModel>[].obs;
  RxList<ProfileModel> filteredProfessionalsCache = <ProfileModel>[].obs;
  RxList<ProfileModel> filteredProfessionalsAdsCache = <ProfileModel>[].obs;
  RxBool filterEnabled = false.obs;
  RxBool filteringEnabled = false.obs;

  late ProfileModel userLogged;

  Rx<String> cepError = ''.obs;
  final searchByCepController = TextEditingController();
  final searchDistrictController = TextEditingController();
  final searchComplementController = TextEditingController();
  final searchProvinceController = TextEditingController();
  final searchCityController = TextEditingController();
  final searchStreetController = TextEditingController();
  final searchNumberController = TextEditingController();
  RxList<String> expertisesFilter = <String>[].obs;
  RxList<String> paymentsFilter = <String>[].obs;
  RxBool statusFilter = false.obs;

  RxBool closeBannerMessage = true.obs;

  @override
  void onInit() {
    loadInitValues();
    super.onInit();
  }

  @override
  void onReady() {
    userLogged = authServices.userLogged;
    getProfessionalByCep(userLogged.addressCEP);
    super.onReady();
  }

  loadInitValues() {
    getCloseBannerMessage();
  }

  checkToEnableSearch() {
    if(expertisesFilter.isNotEmpty || paymentsFilter.isNotEmpty
        || searchByCepController.text.isNotEmpty || searchCityController.text.isNotEmpty
        || searchProvinceController.text.isNotEmpty) {
      filteringEnabled.value = true;
    }
  }
  
  addProfessionalExpertises({String? expertise}) {
    if(expertise != null) {
      expertisesFilter.add(expertise);
    }
    checkToEnableSearch();
  }

  removeProfessionalExpertises({String? expertise}) {
    if(expertise != null) {
      expertisesFilter.removeWhere((e) => e == expertise);
    }
    checkToEnableSearch();
  }

  addPaymentsMethods({String? payment}) {
    if(payment != null) {
      paymentsFilter.add(payment);
    }
    checkToEnableSearch();
  }

  removePaymentsMethods({String? payment}) {
    if(payment != null) {
      paymentsFilter.removeWhere((e) => e == payment);
    }
    checkToEnableSearch();
  }

  searchByCep(FormState? form) async {
    cepError.value = '';
    if(searchByCepController.text.length < 9) {
      cepError.value = 'Informe o CEP antes de pesquisar';
      return;
    }

    loading.value = true;
    final cepFounded = await getAddressByCEP(getRawZipCode(searchByCepController.text));
    loading.value = false;

    if(cepFounded is SearchCepError) {
      cepError.value = cepFounded.errorMessage;
      snackBar(cepFounded.errorMessage);
    } else if(cepFounded is ViaCepInfo) {
      cepError.value = '';
      searchDistrictController.text = cepFounded.bairro ?? '';
      searchComplementController.text = cepFounded.complemento ?? '';
      searchProvinceController.text = cepFounded.uf ?? '';
      searchCityController.text = cepFounded.localidade ?? '';
      searchStreetController.text = cepFounded.logradouro ?? '';
      searchNumberController.text = cepFounded.unidade ?? '';
    }
    checkToEnableSearch();
  }

  cepValidator(String value) {
    if(value.length < 9) return 'Informe um CEP v??lido';
    cepError.value = '';
    return null;
  }

  getProfessionalByCep(String cep) async {
    loading.value = false;
    if(filteredProfessionalsCache.isNotEmpty) {
      filteredProfessionals = filteredProfessionalsCache;
      return;
    }
    loading.value = true;

    QuerySnapshot queryResult = await firestore.collection(collectionProfiles)
        .where("addressCEP", isEqualTo: cep)
        .where("profileType", isEqualTo: 'profissional')
        .orderBy("rate", descending: true)
        .limit(20).get();

    await handleFilterDocs(queryResult.docs);
    loading.value = false;
  }

  submitProfessionalFilterToFirebase() async {
    loading.value = false;
    filterEnabled.value = true;
    loading.value = true;

    Query querys = firestore.collection(collectionProfiles);
    if(expertisesFilter.isNotEmpty) {
      querys = querys.where("expertises", arrayContainsAny: expertisesFilter);
    } else if(paymentsFilter.isNotEmpty && expertisesFilter.isEmpty) {
      querys = querys.where("paymentMethods", arrayContainsAny: paymentsFilter);
    }

    if(searchByCepController.text.isNotEmpty) {
      querys = querys.where("addressCEP", isEqualTo: getRawZipCode(searchByCepController.text));
    }
    if(searchCityController.text.isNotEmpty) {
      querys = querys.where("addressCity", isEqualTo: searchCityController.text);
    }
    if(searchProvinceController.text.isNotEmpty) {
      querys = querys.where("addressProvince", isEqualTo: searchProvinceController.text.toUpperCase());
    }

    if(statusFilter.isTrue) {
      querys = querys.where("status", isEqualTo: 'online');
    }

    QuerySnapshot queryDocs = await querys.where("profileType", isEqualTo: 'profissional')
        .limit(20).orderBy("rate", descending: true).get();

    if(paymentsFilter.isNotEmpty && expertisesFilter.isNotEmpty) {
      handleFilterDocs(filterDocs(queryDocs));
    } else {
      handleFilterDocs(queryDocs.docs);
    }

    loading.value = false;
  }

  setStatusFilter(bool status) {
    statusFilter.value = status;
  }

  List<QueryDocumentSnapshot> filterDocs(QuerySnapshot results) {
    List<QueryDocumentSnapshot> listFiltered = results.docs
    .where((e) {
      var firstListSet = ProfileModel.fromJson(e.data() as Map<String, dynamic>).paymentMethods.toSet();
      var secondListSet = paymentsFilter.toSet();
      return firstListSet.intersection(secondListSet).isNotEmpty;
    }).toList();
    return listFiltered;
  }

  Future handleFilterDocs(List<QueryDocumentSnapshot> results) async {
    try {
      filteredProfessionals.value = results
          .map((e) => ProfileModel.fromJson(e.data() as Map<String, dynamic>)).toList();
      filteredProfessionals.removeWhere((p) => p.firebaseId == userLogged.firebaseId);
      filteredProfessionalsCache = filteredProfessionals;
    } catch(e,st) {
      printException('handleFilterDocs', e, st);
    }
  }

  cleanFilter() {
    filterEnabled.value = false;
    filteringEnabled.value = false;
    statusFilter.value = false;
    cepError.value = '';
    searchByCepController.text = '';
    searchDistrictController.text = '';
    searchComplementController.text = '';
    searchProvinceController.text = '';
    searchCityController.text = '';
    searchStreetController.text = '';
    searchNumberController.text = '';
    paymentsFilter.value = [];
    expertisesFilter.value = [];
    filteredProfessionals = filteredProfessionalsCache;
    filteredProfessionalsAds = filteredProfessionalsAdsCache;
  }

  setCloseBannerMessage() async {
    var _prefs = await prefs();
    _prefs.setBool(keyMessageFilterCep, false);
    closeBannerMessage.value = false;
  }

  getCloseBannerMessage() async {
    var _prefs = await prefs();
    closeBannerMessage.value = _prefs.getBool(keyMessageFilterCep) ?? true;
  }
}