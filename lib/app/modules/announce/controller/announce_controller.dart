import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/notification/custom_local_notification.dart';
import 'package:delivery_servicos/app/modules/announce/controller/service_controller.dart';
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
import '../../home/controller/home_client_controller.dart';
import '../../home/controller/home_professional_controller.dart';
import '../../profile/models/profile_model.dart';
import '../model/service_model.dart';
import 'request_controller.dart';

class AnnounceController extends GetxController with LoaderMixin {
  final ServiceModel? service;
  AnnounceController({this.service});

  AuthServices authServices = Get.find<AuthServices>();
  HomeController homeController = Get.find<HomeController>();
  HomeProfessionalController homeProfessionalController = Get.find<HomeProfessionalController>();
//  HomeClientController homeClientController = Get.find<HomeClientController>();
//  RequestController requestsController = Get.find<RequestController>();
//  ServiceController servicesController = Get.find<ServiceController>();

  RxBool loading = false.obs;
  RxBool loadingMyRequests = false.obs;

  RxList<ServiceModel> myServicesRequests = <ServiceModel>[].obs;

  late ProfileModel userLogged;

  RxBool isTermsAccepted = false.obs;
//  RxBool isValidatedForm = false.obs;
//  RxBool isValidatedPayments = false.obs;
//  RxBool isValidatedExpertises = false.obs;
//  RxBool isValidatedDateService = false.obs;
//  RxBool isValidatedMoneyValues = false.obs;
//  RxString cepError = ''.obs;
//  final serviceCepController = TextEditingController();
//  final serviceDistrictController = TextEditingController();
//  final serviceComplementController = TextEditingController();
//  final serviceProvinceController = TextEditingController();
//  final serviceCityController = TextEditingController();
//  final serviceStreetController = TextEditingController();
//  final serviceNumberController = TextEditingController();
//  final serviceObservationsController = TextEditingController();
//  final serviceMinPriceController = TextEditingController();
//  final serviceMaxPriceController = TextEditingController();
//  RxList<String> serviceExpertise = <String>[].obs;
//  RxList<String> servicePayment = <String>[].obs;
//
//  RxInt createServiceStep = 0.obs;
//  RxString serviceCep = ''.obs;
//  RxString serviceDistrict = ''.obs;
//  RxString serviceComplement = ''.obs;
//  RxString serviceProvince = ''.obs;
//  RxString serviceCity = ''.obs;
//  RxString serviceStreet = ''.obs;
//  RxString serviceNumber = ''.obs;
//  RxString serviceObservations = ''.obs;
//  RxString serviceClientName = ''.obs;
//  RxString servicePhone1 = ''.obs;
//  RxString servicePhone2 = ''.obs;
//  RxString serviceWhatsapp = ''.obs;
//  RxString serviceMinPrice = '0,00'.obs;
//  RxString serviceMaxPrice = '0,00'.obs;
//  Rx<DateTime> serviceDateMin = DateTime.now().obs;
//  Rx<DateTime> serviceDateMax = DateTime.now().obs;

  Rx<ProposalModel>? myProposal;
  RxBool isValidatedProposalPrice = false.obs;
  final proposalObservationsController = TextEditingController();
  final proposalPriceController = TextEditingController();

  @override
  void onInit() {
    loaderListener(loading);
    print('onInit - Get.put(()=>AnnounceController');

    userLogged = authServices.userLogged;
    loadInitialInfos();

    print('Get.currentRoute: ${Get.currentRoute}');
    super.onInit();
  }

  @override
  void onReady() {
    loadingMyRequests.value = true;

    loadInitialInfos();

    userLogged = authServices.userLogged;
    print('onReady - Get.put(()=>AnnounceController');

    loadingMyRequests.value = false;
    super.onReady();
  }

  resetMyProposal() {
    myProposal = null;
  }
  reloadMyProposal() {
    resetMyProposal();
    if(service != null && service!.proposals.isNotEmpty) {
      for(ProposalModel p in service!.proposals) {
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
//    serviceCepController.text = getMaskedZipCode(userLogged.addressCEP);
//    serviceDistrictController.text = userLogged.addressDistrict;
//    serviceComplementController.text = userLogged.addressComplement;

    proposalObservationsController.text = '';
    proposalPriceController.text = '';
    isValidatedProposalPrice.value = false;
  }

  setServiceProposalPrice(value) {
    if(value == '0,00') {
      isValidatedProposalPrice.value = false;
    } else {
      isValidatedProposalPrice.value = true;
    }
  }

  setTermsAccept(bool accepted) {
    FocusManager.instance.primaryFocus?.unfocus();
    proposalPriceController.clearComposing();
    proposalObservationsController.clearComposing();
    isTermsAccepted.value = accepted;
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
    serviceModel.proposals.add(myProposal!.value);

    await FirebaseService.updateServiceData(serviceModel.serviceId, serviceModel.toProposal())
        .then((value) async {
          userLogged.serviceProposals.add(serviceModel.serviceId);
          authServices.userLogged = userLogged;
          await FirebaseService.updateProfileData(userLogged.firebaseId, userLogged.toProposals());

          await CustomLocalNotification().sendPrivateMessaging('Opa! Temos uma proposta para você.',
              "'${userLogged.name.split(' ')[0]}' enviou uma proposta para "
                  "realizar o serviço de '${serviceModel.serviceExpertise.first}.'\n"
                  "Acesse o app para aceitar ou recusar.",
              serviceModel.serviceId.toString(), serviceModel.clientMessagingId);

          clearProposalFields();
          await homeProfessionalController.getServicesByFilters();
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
    serviceModel.proposals.removeWhere((p) => p.professionalId == userLogged.firebaseId);

    await FirebaseService.updateServiceData(serviceModel.serviceId, serviceModel.toProposal())
        .then((value) async {
      userLogged.serviceProposals.removeWhere((s) => s == serviceModel.serviceId);
      authServices.userLogged = userLogged;

      await FirebaseService.updateProfileData(userLogged.firebaseId, userLogged.toProposals());
      resetMyProposal();
      if(this.service != null) {
        this.service!.proposals.removeWhere((p) => p.professionalId == userLogged.firebaseId);
      }
      await homeProfessionalController.getServicesByFilters();
      reloadMyProposal();
    });
    loading.value = false;
    Get.toNamed(Routes.home);
    snackBar('Proposta removida com sucesso');
  }

  rejectProposal(ServiceModel service, ProposalModel proposal) {

  }

  acceptProposal(ServiceModel service, ProposalModel proposal) {

  }

  bool checkMyProposal() {
    return myProposal != null;
  }
  bool checkMyProposalStatus() => checkMyProposal()
      && myProposal!.value.status != 'aprovada';


  bool checkStatusService(String status) => status == 'disponível';

  bool checkIfMyRequest(String serviceId) => serviceId == userLogged.firebaseId;

  clearProposalFields() {
    proposalPriceController.text = '';
    proposalObservationsController.text = '';
    isValidatedProposalPrice.value = false;
    isTermsAccepted.value = false;
  }
}