import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/mixin/loader_mixin.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/util/global_functions.dart';
import '../../../../routes/app_pages.dart';
import '../../../global/constants/constants.dart';
import '../../profile/models/profile_model.dart';
import '../model/proposal_model.dart';
import '../model/service_model.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController with LoaderMixin {
  final ServiceModel? service;
  ServiceController({this.service});
  RxBool loadingMyServices = false.obs;

  AuthServices authServices = Get.find<AuthServices>();

  RxList<ServiceModel> myServicesProposal = <ServiceModel>[].obs;

  late ProfileModel userLogged;
  Rx<ProposalModel> myProposal = ProposalModel(status: 'deletada').obs;

  @override
  void onInit() {
    print('onInit - Get.put(()=>AnnounceController');

    userLogged = authServices.profileModel;

    print('Get.currentRoute: ${Get.currentRoute}');
    super.onInit();
  }

  @override
  void onReady() {
    loadingMyServices.value = true;
    userLogged = authServices.profileModel;

    loadMyServices();

    loadingMyServices.value = false;
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

  loadMyServices() async {
    List<ServiceModel> listFromFirebase = await FirebaseService
        .getListServiceModelDataById('professionalId', userLogged.firebaseId);

    for(String s in userLogged.serviceProposals) {
      QuerySnapshot queryServices = await FirebaseService.firestore
          .collection(collectionServices).where('serviceId', isEqualTo: s).get();

      if(queryServices.docs.isNotEmpty) {
        for(DocumentSnapshot d in queryServices.docs) {
          listFromFirebase.add(ServiceModel.fromJson(d.data() as Map<String, dynamic>));
        }
      }
    }

    myServicesProposal.value = listFromFirebase;
  }
  removeMyProposal(ServiceModel service) async {
    loadingMyServices.value = false;
    loadingMyServices.value = true;

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
      reloadMyProposal();
    });
    loadingMyServices.value = false;
    Get.toNamed(Routes.myServices);
    snackBar('Proposta removida com sucesso');
  }

  bool checkMyProposal() {
    return myProposal.value.status != ProposalModel(status: 'deletada').status;
  }
  bool checkMyProposalStatus() => checkMyProposal()
      && myProposal.value.status != 'aprovada';
}