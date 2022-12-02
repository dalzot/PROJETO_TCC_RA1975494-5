import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/notification/custom_local_notification.dart';
import 'package:delivery_servicos/app/modules/announce/model/proposal_model.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_controller.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_cep/search_cep.dart';

import '../../../../core/util/global_functions.dart';
import '../../../../routes/app_pages.dart';
import '../../profile/models/profile_model.dart';
import '../announce_details_page.dart';
import '../model/service_model.dart';

class AnnounceController extends GetxController with LoaderMixin {
  final ServiceModel? service;
  AnnounceController({this.service});

  AuthServices authServices = Get.find<AuthServices>();
  HomeController homeController = Get.find<HomeController>();
  RxBool loading = false.obs;
  RxBool loadingMyRequests = false.obs;

  RxList<ServiceModel> myServicesRequests = <ServiceModel>[].obs;

  late ProfileModel userLogged;

  RxBool isTermsAccepted = false.obs;
  RxBool isValidatedForm = false.obs;
  RxBool isValidatedPayments = false.obs;
  RxBool isValidatedExpertises = false.obs;
  RxBool isValidatedDateService = false.obs;
  RxBool isValidatedMoneyValues = false.obs;
  RxString cepError = ''.obs;
  final serviceCepController = TextEditingController();
  final serviceDistrictController = TextEditingController();
  final serviceComplementController = TextEditingController();
  final serviceProvinceController = TextEditingController();
  final serviceCityController = TextEditingController();
  final serviceStreetController = TextEditingController();
  final serviceNumberController = TextEditingController();
  final serviceObservationsController = TextEditingController();
  final serviceMinPriceController = TextEditingController();
  final serviceMaxPriceController = TextEditingController();
  RxList<String> serviceExpertise = <String>[].obs;
  RxList<String> servicePayment = <String>[].obs;

  RxInt createServiceStep = 0.obs;
  RxString serviceCep = ''.obs;
  RxString serviceDistrict = ''.obs;
  RxString serviceComplement = ''.obs;
  RxString serviceProvince = ''.obs;
  RxString serviceCity = ''.obs;
  RxString serviceStreet = ''.obs;
  RxString serviceNumber = ''.obs;
  RxString serviceObservations = ''.obs;
  RxString serviceClientName = ''.obs;
  RxString servicePhone1 = ''.obs;
  RxString servicePhone2 = ''.obs;
  RxString serviceWhatsapp = ''.obs;
  RxString serviceMinPrice = '0,00'.obs;
  RxString serviceMaxPrice = '0,00'.obs;
  Rx<DateTime> serviceDateMin = DateTime.now().obs;
  Rx<DateTime> serviceDateMax = DateTime.now().obs;

  Rx<ProposalModel> myProposal = ProposalModel(status: 'deletada').obs;
  RxBool isValidatedProposalPrice = false.obs;
  final proposalObservationsController = TextEditingController();
  final proposalPriceController = TextEditingController();

  @override
  void onInit() {
    loaderListener(loading);
    print('onInit - Get.put(()=>AnnounceController');

    userLogged = authServices.profileModel;
    loadInitialInfos();

    print('Get.currentRoute: ${Get.currentRoute}');
    super.onInit();
  }

  @override
  void onReady() {
    loadingMyRequests.value = true;

    loadInitialInfos();

    userLogged = authServices.profileModel;
    print('onReady - Get.put(()=>AnnounceController');
//    reloadMyProposal();
    loadingMyRequests.value = false;
    super.onReady();
  }

  resetMyProposal() {
    myProposal = ProposalModel(status: 'deletada').obs;
  }
  reloadMyProposal() {
    resetMyProposal();
    if(service != null && service!.proposals!.isNotEmpty) {
      for(ProposalModel p in service!.proposals!) {
        if(p.professionalId == userLogged.firebaseId && !checkMyProposal()) {
          myProposal = p.obs;
        }
      }
    } else {
      resetMyProposal();
    }
  }

  loadInitialInfos() {
    reloadMyProposal();
    serviceCepController.text = getMaskedZipCode(userLogged.addressCEP);
    serviceDistrictController.text = userLogged.addressDistrict;
    serviceComplementController.text = userLogged.addressComplement;
    serviceProvinceController.text = userLogged.addressProvince;
    serviceCityController.text = userLogged.addressCity;
    serviceStreetController.text = userLogged.addressStreet;
    serviceNumberController.text = userLogged.addressNumber;

    serviceCep.value = getMaskedZipCode(userLogged.addressCEP);
    serviceDistrict.value = userLogged.addressDistrict;
    serviceComplement.value = userLogged.addressComplement;
    serviceProvince.value = userLogged.addressProvince;
    serviceCity.value = userLogged.addressCity;
    serviceStreet.value = userLogged.addressStreet;
    serviceNumber.value = userLogged.addressNumber;
    serviceClientName.value = userLogged.name;
    servicePhone1.value = userLogged.phoneNumber;
    servicePhone2.value = userLogged.phoneNumber2;
    serviceWhatsapp.value = userLogged.whatsapp;
    serviceObservations.value = '';
    serviceMinPrice.value = '0,00';
    serviceMaxPrice.value = '0,00';
    cepError.value = '';
    DateTime now = DateTime.now();
    serviceDateMin.value = DateTime(now.year, now.month, now.day, 0,0,0);
    serviceDateMax.value = DateTime(now.year, now.month, now.day, 0,0,0);
    isTermsAccepted.value = false;
    isValidatedForm.value = false;
    isValidatedPayments.value = false;
    isValidatedExpertises.value = false;
    isValidatedDateService.value = false;
    isValidatedMoneyValues.value = false;

    proposalObservationsController.text = '';
    proposalPriceController.text = '';
    isValidatedProposalPrice.value = false;
  }

  loadMySolicitations() async {
    if(myServicesRequests.isNotEmpty) return;

    List<ServiceModel> listFromFirebase = await FirebaseService
        .getListServiceModelDataById('clientId', userLogged.firebaseId);
    myServicesRequests.value = listFromFirebase;
  }

  checkToEnableUpdateAddress() {
    if(serviceCepController.text.isNotEmpty
        && serviceDistrictController.text.isNotEmpty
        && serviceProvinceController.text.isNotEmpty
        && serviceCityController.text.isNotEmpty
        && serviceStreetController.text.isNotEmpty
        && serviceNumberController.text.isNotEmpty
    ) {
      isValidatedForm.value = true;
    } else {
      isValidatedForm.value = false;
    }
  }

  validateAddressForm(FormState? form) {
    if (form != null && form.validate()) {
      isValidatedForm.value = true;
    } else {
      isValidatedForm.value = false;
    }
  }

  validatedPaymentsForm() {
    if (servicePayment.isNotEmpty) {
      isValidatedPayments.value = true;
    } else {
      isValidatedPayments.value = false;
    }
  }

  validatedExpertisesForm() {
    if (serviceExpertise.isNotEmpty) {
      isValidatedExpertises.value = true;
    } else {
      isValidatedExpertises.value = false;
    }
  }

  validateMoneyValues() {
    if (serviceMinPriceController.text.isNotEmpty && serviceMinPriceController.text.trim() != '0,00'
        && serviceMaxPriceController.text.isNotEmpty && serviceMaxPriceController.text.trim() != '0,00') {
      isValidatedMoneyValues.value = true;
    } else {
      isValidatedMoneyValues.value = false;
    }
  }
  setMoneyValues(value) {
    if(value == '0,00') {
      isValidatedMoneyValues.value = false;
    }
    validateMoneyValues();
  }

  setServiceProposalPrice(value) {
    if(value == '0,00') {
      isValidatedProposalPrice.value = false;
    } else {
      isValidatedProposalPrice.value = true;
    }
  }

  setServiceDateMin(value) {
    serviceDateMin.value = value;
    validateDateTimes();
  }
  setServiceDateMax(value) {
    serviceDateMax.value = value;
    validateDateTimes();
  }
  validateDateTimes() {
    if(serviceDateMin.value.hour != 0 && serviceDateMax.value.hour != 0) {
      isValidatedDateService.value = true;
    } else {
      isValidatedDateService.value = false;
    }
  }

  setTermsAccept(bool accepted) {
    FocusManager.instance.primaryFocus?.unfocus();
    proposalPriceController.clearComposing();
    proposalObservationsController.clearComposing();
    isTermsAccepted.value = accepted;
  }
  
  setNextStep() {
    if(createServiceStep.value < 5) {
      createServiceStep.value ++;
    }
  }

  addProfessionalExpertises({String? expertise}) {
    if(expertise != null) {
      serviceExpertise.add(expertise);
    }
    validatedExpertisesForm();
  }

  removeProfessionalExpertises({String? expertise}) {
    if(expertise != null) {
      serviceExpertise.removeWhere((e) => e == expertise);
    }
    validatedExpertisesForm();
  }

  addPaymentsMethods({String? payment}) {
    if(payment != null) {
      servicePayment.add(payment);
    }
    validatedPaymentsForm();
  }

  removePaymentsMethods({String? payment}) {
    if(payment != null) {
      servicePayment.removeWhere((e) => e == payment);
    }
    validatedPaymentsForm();
  }

  searchByCep(FormState? form) async {
    cepError.value = '';
    if(serviceCepController.text.length < 9) {
      cepError.value = 'Informe o CEP antes de pesquisar';
      return;
    }

    loading.value = true;
    final cepFounded = await getAddressByCEP(getRawZipCode(serviceCepController.text));
    loading.value = false;

    if(cepFounded is SearchCepError) {
      cepError.value = cepFounded.errorMessage;
      snackBar(cepFounded.errorMessage);
    } else if(cepFounded is ViaCepInfo) {
      cepError.value = '';
      serviceDistrictController.text = cepFounded.bairro ?? serviceDistrictController.text;
      serviceComplementController.text = cepFounded.complemento ?? serviceComplementController.text;
      serviceProvinceController.text = cepFounded.uf ?? serviceProvinceController.text;
      serviceCityController.text = cepFounded.localidade ?? serviceCityController.text;
      serviceStreetController.text = cepFounded.logradouro != null && cepFounded.logradouro != ''
          ? cepFounded.logradouro.toString() : serviceStreetController.text;
      serviceNumberController.text = cepFounded.unidade ?? serviceNumberController.text;
    }
  }

  cepValidator(String value) {
    if(value.length < 9) return 'Informe um CEP válido';
    if(cepError.value != '') return cepError.value;
    return null;
  }

  updateCurrentAddress() {
    serviceCep.value = getRawZipCode(serviceCepController.text);
    serviceDistrict.value = serviceDistrictController.text;
    serviceComplement.value = serviceComplementController.text;
    serviceProvince.value = serviceProvinceController.text;
    serviceCity.value = serviceCityController.text;
    serviceStreet.value = serviceStreetController.text;
    serviceNumber.value = serviceNumberController.text;
  }

  updateObservations() {
    serviceObservations.value = serviceObservationsController.text;
  }

  updateMinMaxPrices() {
    serviceMinPrice.value = serviceMinPriceController.text;
    serviceMaxPrice.value = serviceMaxPriceController.text;
  }

  submitServiceToFirebase() async {
    loading.value = false;
    loading.value = true;

    ServiceModel serviceModel = ServiceModel(
      serviceId: '${getRawDate(dateNowString())}_${userLogged.firebaseId}',
      clientId: userLogged.firebaseId,
      clientMessagingId: userLogged.firebaseMessagingId,
      professionalId: null,
      cep: getRawZipCode(serviceCep.value),
      district: serviceDistrict.value,
      complement: serviceComplement.value,
      province: serviceProvince.value,
      city: serviceCity.value,
      street: serviceStreet.value,
      number: serviceNumber.value,
      observations: serviceObservations.value,
      clientName: serviceClientName.value,
      phone1: servicePhone1.value,
      phone2: servicePhone2.value,
      whatsapp: serviceWhatsapp.value,
      minPrice: serviceMinPrice.value,
      maxPrice: serviceMaxPrice.value,
      dateMin: dateTimeFormat(serviceDateMin.value),
      dateMax: dateTimeFormat(serviceDateMax.value),
      serviceExpertise: serviceExpertise,
      servicePayment: servicePayment,
      dateCreated: dateNowString(),
      dateUpdated: '',
      dateApproved: '',
      status: 'disponível',
      proposals: []
    );

    await FirebaseService.setServiceData(serviceModel.serviceId, serviceModel.toJson());
    snackBar('Solicitação enviada com sucesso');

    myServicesRequests.add(serviceModel);

    cleanFilter();
    loading.value = false;
  }

  submitProposalToClient(ServiceModel service) async {
    loading.value = false;
    loading.value = true;

    ServiceModel serviceModel = await FirebaseService.getServiceModelData(service.serviceId);
    myProposal = ProposalModel(
      dateCreated: dateNowString(),
      dateUpdated: '',
      status: 'enviada',
      reasonRecuse: '',
      observations: proposalObservationsController.text,
      phone1: userLogged.phoneNumber,
      price: proposalPriceController.text,
      professionalId: userLogged.firebaseId,
      professionalMessagingId: userLogged.firebaseMessagingId,
      professionalName: userLogged.name,
    ).obs;
    serviceModel.proposals!.add(myProposal.value);

    await FirebaseService.updateServiceData(serviceModel.serviceId, serviceModel.toProposal())
        .then((value) async {
          userLogged.serviceProposals.add(serviceModel.serviceId!);
          authServices.profileModel = userLogged;
          await FirebaseService.updateProfileData(userLogged.firebaseId, userLogged.toProposals());

          await CustomLocalNotification().sendPrivateMessaging('Opa! Temos uma proposta para você.',
              "'${userLogged.name.split(' ')[0]}' enviou uma proposta para "
                  "realizar o serviço de '${serviceModel.serviceExpertise!.first}.'\n"
                  "Acesse o app para aceitar ou recusar.",
              serviceModel.serviceId.toString(), serviceModel.clientMessagingId!);

          clearProposalFields();
          await homeController.getServicesByFilters();
          reloadMyProposal();
    });
    loading.value = false;
    Get.toNamed(Routes.home);
    snackBar('Proposta enviada com sucesso');
  }

  removeMyProposal(ServiceModel service) async {
    loading.value = false;
    loading.value = true;

    ServiceModel serviceModel = await FirebaseService.getServiceModelData(service.serviceId);
    serviceModel.proposals!.removeWhere((p) => p.professionalId == userLogged.firebaseId);

    await FirebaseService.updateServiceData(serviceModel.serviceId, serviceModel.toProposal())
        .then((value) async {
      userLogged.serviceProposals.removeWhere((s) => s == serviceModel.serviceId!);
      authServices.profileModel = userLogged;

      await FirebaseService.updateProfileData(userLogged.firebaseId, userLogged.toProposals());
      resetMyProposal();
      if(this.service != null) {
        this.service!.proposals!.removeWhere((p) => p.professionalId == userLogged.firebaseId);
      }
      await homeController.getServicesByFilters();
      reloadMyProposal();
    });
    loading.value = false;
    Get.toNamed(Routes.home);
    snackBar('Proposta removida com sucesso');
  }

//  callToDetails(ServiceModel service) {
//    Get.lazyPut(() => AnnounceController(service: service));
//    Get.offAll(()=>AnnounceDetailsPage(service: service));
////    Get.offAll(()=>AnnounceDetailsPage(service: service));
//  }

  bool checkMyProposal() {
    return myProposal.value.status != ProposalModel(status: 'deletada').status;
  }
  bool checkMyProposalStatus() => checkMyProposal()
      && myProposal.value.status != 'aprovada';

  cleanFilter() {
    cepError.value = '';
    servicePayment.value = [];
    serviceExpertise.value = [];
    serviceCepController.text = '';
    serviceDistrictController.text = '';
    serviceComplementController.text = '';
    serviceProvinceController.text = '';
    serviceCityController.text = '';
    serviceStreetController.text = '';
    serviceNumberController.text = '';
    serviceObservationsController.text = '';
    resetFields();
  }
  resetFields() {
    DateTime now = DateTime.now();
    serviceObservations.value = '';
    serviceMinPrice.value = '0,00';
    serviceMaxPrice.value = '0,00';
    cepError.value = '';
    serviceDateMin.value = DateTime(now.year, now.month, now.day, 0,0,0);
    serviceDateMax.value = DateTime(now.year, now.month, now.day, 0,0,0);
    isTermsAccepted.value = false;
    isValidatedForm.value = false;
    isValidatedPayments.value = false;
    isValidatedExpertises.value = false;
    isValidatedDateService.value = false;
    isValidatedMoneyValues.value = false;
  }
  clearProposalFields() {
    proposalPriceController.text = '';
    proposalObservationsController.text = '';
    isValidatedProposalPrice.value = false;
    isTermsAccepted.value = false;
  }
}