import 'package:delivery_servicos/app/global/notification/custom_local_notification.dart';
import 'package:delivery_servicos/app/modules/announce/model/proposal_model.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/util/global_functions.dart';
import '../../../../routes/app_pages.dart';
import '../../home/controller/home_professional_controller.dart';
import '../../profile/models/profile_model.dart';
import '../../profile/models/rate_model.dart';
import '../model/service_model.dart';

class AnnounceController extends GetxController with LoaderMixin {
  ServiceModel? service;
  AnnounceController({this.service});

  AuthServices authServices = Get.find<AuthServices>();
  HomeProfessionalController homeProfessionalController = Get.find<HomeProfessionalController>();

  RxBool loading = false.obs;
  RxBool loadingMyRequests = false.obs;

  RxList<ServiceModel> myServicesRequests = <ServiceModel>[].obs;
  RxList<ProposalModel> myServicesProposals = <ProposalModel>[].obs;

  late ProfileModel userLogged;

  RxBool isTermsAccepted = false.obs;
  RxBool isObservationFinal = false.obs;

  Rx<ProposalModel>? myProposal;
  RxBool isValidatedProposalPrice = false.obs;
  final proposalObservationsController = TextEditingController();
  final proposalPriceController = TextEditingController();
  final observationsFinalController = TextEditingController();
  RxString observationsFinal = ''.obs;
  RxInt rateService = 0.obs;
  RxInt ratePrice = 0.obs;
  RxInt rateProfessional = 0.obs;

  @override
  void onInit() {
    loaderListener(loading);
    loadingMyRequests.value = true;
    userLogged = authServices.userLogged;
    loadInitialInfos();
    super.onInit();
  }

  @override
  void onReady() {
    loadingMyRequests.value = true;
    loadInitialInfos();
    userLogged = authServices.userLogged;
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
    proposalObservationsController.text = '';
    proposalPriceController.text = '';
    isValidatedProposalPrice.value = false;
  }

  setServiceAndProposals(ServiceModel serviceModel) async {
    service = serviceModel;
    myServicesProposals.addAll(serviceModel.proposals);
//    await Future.delayed(const Duration(seconds: 1));
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

  changeObservationsFinal(obs) {
    observationsFinal.value = obs;
    if(obs.isNotEmpty) {
      isObservationFinal.value = true;
    } else {
      isObservationFinal.value = false;
    }
  }

  changeRateService(value) {
    rateService.value = value;
  }
  changeRatePrice(value) {
    ratePrice.value = value;
  }
  changeRateProfessional(value) {
    rateProfessional.value = value;
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
          ProfileModel profileEdited = authServices.userLogged;
          List<String> proposalsEdited = List.from(profileEdited.serviceProposals);
          proposalsEdited.add(serviceModel.serviceId);
          profileEdited.serviceProposals = proposalsEdited;

          authServices.userLogged = profileEdited;
          userLogged = profileEdited;
          await FirebaseService.updateProfileData(userLogged.firebaseId, profileEdited.toProposals());

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
//    Get.offAllNamed(Routes.home);
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
    Get.offAllNamed(Routes.myServices);
    snackBar('Proposta removida com sucesso');
  }

  acceptOrRecuseProposal(ServiceModel serviceParam, ProposalModel proposal, bool acceptOrRecuse, {String? reason}) async {
    loading.value = false;
    loading.value = true;
    List<ProposalModel> proposalsEdited = [];

    proposal.status = acceptOrRecuse ? 'aprovada' : 'recusada';
    proposal.dateUpdated = dateNowString();
    proposal.reasonRecuse = reason ?? '';
    proposalsEdited.add(proposal);

    for(ProposalModel p in serviceParam.proposals) {
      if(p.professionalId != proposal.professionalId) {
        if(acceptOrRecuse) {
          p.status = 'recusada';
          p.dateUpdated = dateNowString();
          p.reasonRecuse = 'O cliente aceitou outra proposta.\n'
              'Mas não se preocupe, existem milhares de ofertas de serviço disponíveis no app.';

          await CustomLocalNotification().sendPrivateMessaging('Ahh! Sua proposta foi recusada 😏',
              "'${userLogged.name.split(' ')[0]}' acabou aceitando outra proposta.'\n"
                  "Acesse o app para conferir.",
              serviceParam.serviceId.toString(),
              p.professionalMessagingId.toString());
        }
        proposalsEdited.add(p);
      }
    }
    serviceParam.proposals = proposalsEdited;
    serviceParam.dateUpdated = dateNowString();
    if(acceptOrRecuse) {
      serviceParam.professionalId = proposal.professionalId.toString();
      serviceParam.status = 'executando';
    }
    print('acceptOrRecuse: $acceptOrRecuse - ${serviceParam.toProposalAccept()}');

    await FirebaseService.updateServiceData(serviceParam.serviceId,
        acceptOrRecuse ? serviceParam.toProposalAccept() : serviceParam.toProposal()
    ).then((value) async {
      await CustomLocalNotification().sendPrivateMessaging(
          acceptOrRecuse ? 'Eba! Sua proposta foi aprovada 😃' : 'Ahh! Sua proposta foi recusada 😏',
          "'${userLogged.name.split(' ')[0]}' ${acceptOrRecuse ? 'aprovou' : 'recusou'} sua proposta no serviço "
              "'${serviceParam.serviceExpertise.first}.'\n"
              "Acesse o app para conferir.",
          serviceParam.serviceId.toString(),
          proposal.professionalMessagingId.toString());
    });
    myServicesProposals.value = serviceParam.proposals;
    loading.value = false;
  }

  finalizeOrRateService(ServiceModel serviceParam, bool finalizeOrRate) async {
    loading.value = true;

    serviceParam.dateUpdated = dateNowString();
    serviceParam.status = finalizeOrRate ? 'avaliar' : 'finalizado';
    if(finalizeOrRate) {
      serviceParam.observationsFinal = observationsFinal.value;
    }

    await FirebaseService.updateServiceData(serviceParam.serviceId, serviceParam.toFinalize())
        .then((value) async {
          ProfileModel professionalProfile = await FirebaseService.getProfileModelData(serviceParam.professionalId);
          if(!finalizeOrRate) {
            professionalProfile.allRates.add(RateModel(
              rateService: rateService.value,
              ratePrice: ratePrice.value,
              rateProfessional: rateProfessional.value,
            ));
            await FirebaseService.updateProfileData(professionalProfile.firebaseId, professionalProfile.toUpdateRates());
          }
          await CustomLocalNotification().sendPrivateMessaging(
            finalizeOrRate ? 'Seu serviço foi finalizado!' : 'Parabéns, você recebeu uma avaliação!',
            finalizeOrRate
                ? "'${professionalProfile.name.toString().split(' ')[0]}' "
                "finalizou seu serviço e está aguardando sua avaliação.\nAcesse o app para avaliá-lo."
                : "'${serviceParam.clientName.toString().split(' ')[0]}' "
                "enviou a avaliação do seu serviço prestado.\nAcesse o app para visualizar.",
            serviceParam.serviceId.toString(),
            finalizeOrRate
                ? serviceParam.clientMessagingId.toString()
                : professionalProfile.firebaseMessagingId);
          await homeProfessionalController.getServicesByFilters();
    });
    loading.value = false;
    if(finalizeOrRate) {
      Get.offAllNamed(Routes.myServices);
    } else {
      Get.offAllNamed(Routes.myRequests);
    }
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