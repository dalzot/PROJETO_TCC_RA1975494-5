import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_cep/search_cep.dart';

import '../../../../core/mixin/loader_mixin.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../global/constants/constants.dart';

class EditController extends GetxController with LoaderMixin {
  final loading = false.obs;

  // Account Infos
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();

  // Personal Infos
  final birthdayController = TextEditingController();
  final cpfController = TextEditingController();
  final rgController = TextEditingController();
  final rgEmitController = TextEditingController();
  final phoneController = TextEditingController();
  final phone2Controller = TextEditingController();
  Rx<TextInputMask> maskPhone = TextInputMask(mask: '(99) 9999-99999').obs;

  // Social Links
  final whatsappController = TextEditingController();
  final telegramController = TextEditingController();
  final facebookController = TextEditingController();
  final linkedinController = TextEditingController();
  final instagramController = TextEditingController();

  // Address Info
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cepController = TextEditingController();
  final complementController = TextEditingController();
  Rx<String> cepError = ''.obs;

  // Biography and Payment
  final biographyController = TextEditingController();
  final otherPaymentsController = TextEditingController();
  RxList<String> paymentMethods = <String>[].obs;

  // Professional Info
  RxList<String> profileExpertises = <String>[].obs;

  //RxString messageEmailAlreadyUse = ''.obs;
  RxString profileType = ''.obs;
  RxBool passEquals = false.obs;
  RxBool passChanged = false.obs;
  RxInt editStep = 0.obs;
  late RxBool isAccountFormValidated = false.obs;
  late RxBool isPersonalFormValidated = false.obs;
  late RxBool isAddressFormValidated = false.obs;
  late RxBool isExpertisesFormValidated = false.obs;
  late RxBool isSocialFormValidated = true.obs;
  late RxBool isBioPaymentFormValidated = false.obs;

//  late ProfileModel profileToEdit;

  AuthServices? _authService;

  Future<EditController> init() async {
    return this;
  }

  @override
  void onInit() {
    loaderListener(loading);
    super.onInit();
  }

  @override
  void onReady() {
    _authService = Get.find<AuthServices>();
    super.onReady();
  }

  setProfileToEdit(ProfileModel profile) {
    setTextFields(profile);
  }

  changeMaskPhone(value) {
    maskPhone.value = getRawPhoneNumber(value).length < 10
        ? TextInputMask(mask: '(99) 9999-99999') : TextInputMask(mask: '(99) 9 9999-9999');
  }

  void validatePersonalForm(FormState? form) {
    if (form != null && form.validate()) {
      isPersonalFormValidated.value = true;
    } else {
      isPersonalFormValidated.value = false;
    }
  }

  void validateAddressForm(FormState? form) {
    if(cepController.text.length == 9) {
      cepError.value = '';
    }
    if (form != null && form.validate() && cepError.value == '') {
      isAddressFormValidated.value = true;
    } else {
      isAddressFormValidated.value = false;
    }
  }

  void validateExpertisesForm() {
    if (profileExpertises.isNotEmpty) {
      isExpertisesFormValidated.value = true;
    } else {
      isExpertisesFormValidated.value = false;
    }
  }

  void validateBioPaymentForm() {
    if (paymentMethods.isNotEmpty) {
      isBioPaymentFormValidated.value = true;
    } else {
      isBioPaymentFormValidated.value = false;
    }
  }

  void validateSocialForm() {
    isSocialFormValidated.value = true;
  }

  String? validatorDocId(String? docId) {
    if (docId!.isEmpty) {
      return "CPF obrigatório.";
    } else if (!validationCPF(docId)) {
      return "CPF inválido.";
    }
    return null;
  }

  setNextEditStep() {
    if((profileType.value == 'profissional' && editStep.value < 5)
    || (profileType.value == 'cliente' && editStep.value < 3)) {
      editStep.value += 1;
    }
  }

  setPreviousEditStep() {
    if(editStep.value > 0) {
      editStep.value -= 1;
    }
  }

  addProfessionalExpertises({String? expertise}) {
    if(expertise != null) {
      profileExpertises.add(expertise);
    }
    validateExpertisesForm();
  }

  removeProfessionalExpertises({String? expertise}) {
    if(expertise != null) {
      profileExpertises.removeWhere((e) => e == expertise);
    }
    validateExpertisesForm();
  }

  addPaymentsMethods({String? payment, FormState? form}) {
    if(payment != null) {
      paymentMethods.add(payment);
    }
    validateBioPaymentForm();
  }

  removePaymentsMethods({String? payment, FormState? form}) {
    if(payment != null) {
      paymentMethods.removeWhere((e) => e == payment);
    }
    validateBioPaymentForm();
  }

  searchByCep(FormState? form) async {
    cepError.value = '';
    if(cepController.text.length < 9) {
      cepError.value = 'Informe o CEP antes de pesquisar';
      return;
    }

    loading.value = true;
    final cepFounded = await getAddressByCEP(getRawZipCode(cepController.text));
    loading.value = false;

    if(cepFounded is SearchCepError) {
      cepError.value = cepFounded.errorMessage;
      snackBar(cepFounded.errorMessage);
    } else if(cepFounded is ViaCepInfo) {
      cepError.value = '';
      districtController.text = cepFounded.bairro ?? '';
      complementController.text = cepFounded.complemento ?? '';
      provinceController.text = cepFounded.uf ?? '';
      cityController.text = cepFounded.localidade ?? '';
      streetController.text = cepFounded.logradouro ?? '';
      validateAddressForm(form);
    }
  }

  cepValidator(String value) {
    if(value.length < 9) return 'Informe um CEP válido';
    if(cepError.value != '') return cepError.value;
    return null;
  }

  // Envia os dados para o firebase
  submitDataToFirebase() async {
    ProfileModel currentProfile = _authService!.profileModel;

    loading.value = false;
    ProfileModel profileData = ProfileModel(
      firebaseId: _authService!.auth.currentUser!.uid,
      phoneNumber: getRawPhoneNumber(phoneController.text),
      phoneNumber2: getRawPhoneNumber(phone2Controller.text),
      biographyDetails: biographyController.text,
      otherPayments: otherPaymentsController.text,
      paymentMethods: paymentMethods,
      facebook: facebookController.text,
      instagram: instagramController.text,
      linkedin: linkedinController.text,
      telegram: telegramController.text,
      whatsapp: getRawPhoneNumber(whatsappController.text),
      addressStreet: streetController.text,
      addressNumber: numberController.text,
      addressComplement: complementController.text,
      addressCity: cityController.text,
      addressProvince: provinceController.text,
      addressDistrict: districtController.text,
      addressCEP: cepController.text,
      addressLatGPS: '',
      addressLngGPS: '',
      expertises: profileExpertises,
      dateUpdated: dateNowString(),
    );
    loading.value = true;

    ProfileModel profile = await setUserByFirebaseData(profileData);
    _authService!.profileModel.updateProfile(profile);

    loading.value = false;
    setNextEditStep();
  }

  Future<ProfileModel> setUserByFirebaseData(ProfileModel profileData) async {
    await FirebaseFirestore.instance
        .collection(collectionProfiles)
        .doc(profileData.firebaseId)
        .update(profileData.toEditJson());
    return profileData;
  }

  setTextFields(ProfileModel profileToEdit) {
    isBioPaymentFormValidated.value = true;
    isExpertisesFormValidated.value = true;
    isAddressFormValidated.value = true;
    isPersonalFormValidated.value = true;

    editStep.value = 0;
    profileType.value = profileToEdit.profileType;
    profileExpertises = profileToEdit.expertises.obs;
    paymentMethods = profileToEdit.paymentMethods.obs;

    nameController.text = profileToEdit.name;
    birthdayController.text = stringFromDateString(profileToEdit.dateBirthday);
    cpfController.text = profileToEdit.docCpf;
    rgController.text = profileToEdit.docRg;
    rgEmitController.text = getMaskedRGEmit(profileToEdit.docRgEmit).toUpperCase();
    phoneController.text = getMaskedPhoneNumber(profileToEdit.phoneNumber);
    phone2Controller.text = getMaskedPhoneNumber(profileToEdit.phoneNumber2);
    whatsappController.text = getMaskedPhoneNumber(profileToEdit.whatsapp);
    telegramController.text = profileToEdit.telegram;
    facebookController.text = profileToEdit.facebook;
    linkedinController.text = profileToEdit.linkedin;
    instagramController.text = profileToEdit.instagram;
    provinceController.text = profileToEdit.addressProvince;
    cityController.text = profileToEdit.addressCity;
    districtController.text = profileToEdit.addressDistrict;
    streetController.text = profileToEdit.addressStreet;
    numberController.text = profileToEdit.addressNumber;
    complementController.text = profileToEdit.addressComplement;
    cepController.text = getMaskedZipCode(profileToEdit.addressCEP);
    biographyController.text = profileToEdit.biographyDetails;
    otherPaymentsController.text = profileToEdit.otherPayments;

    validateExpertisesForm();
    validateBioPaymentForm();
  }

  clearTextFields() {
    profileType.value = '';
    editStep.value = 0;

    nameController.clear();
    birthdayController.clear();
    cpfController.clear();
    rgController.clear();
    rgEmitController.clear();
    phoneController.clear();
    phone2Controller.clear();
    whatsappController.clear();
    facebookController.clear();
    linkedinController.clear();
    instagramController.clear();
    provinceController.clear();
    cityController.clear();
    districtController.clear();
    streetController.clear();
    numberController.clear();
    complementController.clear();
    cepController.clear();
    otherPaymentsController.clear();
    biographyController.clear();
  }

  @override
  void onClose() {
    clearTextFields();

    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    passConfirmController.dispose();
    birthdayController.dispose();
    cpfController.dispose();
    rgController.dispose();
    rgEmitController.dispose();
    phoneController.dispose();
    phone2Controller.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    linkedinController.dispose();
    instagramController.dispose();
    provinceController.dispose();
    cityController.dispose();
    districtController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    cepController.dispose();
    otherPaymentsController.dispose();
    biographyController.dispose();
    super.onClose();
  }

  callDialog() => globalAlertDialog(
    title: 'Sair do modo de edição?',
    labelActionButton: 'SIM',
    colorOk: null,
    text: 'Se você sair agora, todas as alterações serão descartadas.',
    onPressedAction: () {
      clearTextFields();
      Get.offAllNamed(Routes.profile);
    },
  );
}
