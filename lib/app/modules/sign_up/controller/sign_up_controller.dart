import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:search_cep/search_cep.dart';

import '../../../../core/mixin/loader_mixin.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';

class SignUpController extends GetxController with LoaderMixin {
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
  RxInt signUpStep = 0.obs;
  late RxBool isAccountFormValidated = false.obs;
  late RxBool isPersonalFormValidated = false.obs;
  late RxBool isAddressFormValidated = false.obs;
  late RxBool isExpertisesFormValidated = false.obs;
  late RxBool isSocialFormValidated = true.obs;
  late RxBool isBioPaymentFormValidated = false.obs;

  AuthServices? _authService;

  Future<SignUpController> init() async {
    return this;
  }

  @override
  void onInit() {
    loaderListener(loading);
    clearTextFields();
    super.onInit();
  }

  @override
  void onReady() {
    _authService = Get.find<AuthServices>();
    super.onReady();
  }

  void validateAccountForm(FormState? form) {
    if(passController.text.isEmpty && passConfirmController.text.isEmpty) {
      passEquals.value = false;
      passChanged.value = false;
    } else {
      passEquals.value = passController.text == passConfirmController.text;
      passChanged.value = true;
    }
    if (form != null && form.validate()
        && ((passChanged.value && passEquals.value))
        && profileType.value.trim() != ''
    ) {
      isAccountFormValidated.value = true;
    } else {
      isAccountFormValidated.value = false;
    }
  }

  void validatePersonalForm(FormState? form) {
    if (form != null && form.validate()) {
      isPersonalFormValidated.value = true;
    } else {
      isPersonalFormValidated.value = false;
    }
  }

  void validateAddressForm(FormState? form) {
    if(cepController.text.length == 10) {
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

  setNextSignUpStep() async {
    if(signUpStep.value == 0) {
      // Checa se existe alguém já cadastrado com mesmo CPF
      bool exists = await FirebaseService.checkIfDocsRegistered(
          getRawZipCode(cpfController.text), getRawZipCode(rgController.text));
      if(exists) {
        snackBar('CPF ou RG já cadastrados para outro usuário');
        return;
      }
    }
    if((profileType.value == 'profissional' && signUpStep.value < 5)
    || (profileType.value == 'cliente' && signUpStep.value < 3)) {
      signUpStep.value += 1;
    }
  }

  setPreviousSignUpStep() {
    if(signUpStep.value > 0) {
      signUpStep.value -= 1;
    }
  }

  setProfileType(String type, FormState? form) async {
    profileType.value = type;
    validateAccountForm(form);
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

  // Registra a conta do usuário no firebase
  submitSignUpEmailAccount() async {
    loading.value = false;
    if(emailController.text.isEmpty || passController.text.isEmpty) {
      return snackBar(emailController.text.isEmpty
          ? 'Informe um email válido'
          : 'Informe uma senha válida');
    }
    loading.value = true;

    UserCredential? credentials = await _authService!.createUserByEmail(
        emailController.text, passController.text);

    if(_authService!.authServiceError == 'email-already-in-use') {
      loading.value = false;
      clearTextFields();
      Get.offAllNamed(Routes.signIn);
      snackBar('Esse email já está sendo utilizado, faça o login para continuar.');
      return;
    }

//    setPassTemp(passController.text);
    loading.value = false;
    if(credentials != null) {
      User? user = credentials.user!;
      await _authService!.setUserByFirebaseData(ProfileModel(
        name: nameController.text,
        profileType: profileType.value,
        email: emailController.text,
        password: passController.text,
        firebaseId: user.uid
      ));

      if (user != null && profileType.value != '') {
        if(profileType.value == 'profissional') {
          Get.offAllNamed(Routes.signUpProfessional);
        } else {
          Get.offAllNamed(Routes.signUpClient);
        }
      } else {
        clearTextFields();
        snackBar('Usuário não encontrado');
      }
    } else {
      clearTextFields();
      snackBar('Falha na autenticação');
    }
  }

  // Envia os dados para o firebase
  submitDataToFirebase() async {
    loading.value = false;
    loading.value = true;
    final p = await prefs();
    String? firebaseMessaging = await FirebaseService.getFirebaseMessagingToken();
    ProfileModel profileData = ProfileModel(
      firebaseId: _authService!.auth.currentUser!.uid,
      name: nameController.text,
      docCpf: getRawZipCode(cpfController.text),
      docRg: getRawZipCode(rgController.text),
      docRgEmit: rgEmitController.text.replaceAll('/', ''),
      dateBirthday: birthdayController.text,
      phoneNumber: getRawPhoneNumber(phoneController.text),
      phoneNumber2: getRawPhoneNumber(phone2Controller.text),
      biographyDetails: biographyController.text,
      otherPayments: otherPaymentsController.text,
      paymentMethods: paymentMethods,
      email: emailController.text,
      password: passController.text,
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
      status: 'offline',
      profileType: profileType.value,
      showFullName: false,
      showFullAddress: false,
      rate: 0.0,
      level: 0,
      qtdRequests: 0,
      totalRequests: 0.0,
      expertises: profileExpertises,
      dateUpdated: dateNowString(),
      dateCreated: dateNowString(),
      dateLastView: dateNowString(),
      firebaseMessagingId: firebaseMessaging.toString(),
    );
    p.setString(userLoginMail, profileData.email);

    await _authService!.setUserByFirebaseData(profileData);

    loading.value = false;
    clearTextFields();
    signUpStep.value = 5;
  }

  deleteAccount() async {
    loading.value = false;
    final User? user = _authService!.auth.currentUser;
    if (user == null) return;
    loading.value = true;
    await _authService!.deleteUserData();
    loading.value = false;

    logout();
    Get.offAllNamed(Routes.signIn);
    snackBar('Você poderá cadastrar-se mais tarde se preferir');
  }

  clearTextFields() {
    paymentMethods.clear();
    profileExpertises.clear();
    nameController.clear();
    emailController.clear();
    passController.clear();
    passConfirmController.clear();
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
    biographyController.clear();
    otherPaymentsController.clear();
    profileType.value = '';
//    signUpStep.value = 0;
  }

  setTextFieldsTemp(ProfileModel profile) async {
    signUpStep.value = 0;
    profileType.value = profile.profileType;
    nameController.text = profile.name;
    emailController.text = profile.email;
    passController.text = profile.password;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    passConfirmController.dispose();
    cpfController.dispose();
    rgController.dispose();
    rgEmitController.dispose();
    phoneController.dispose();
    phone2Controller.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    linkedinController.dispose();
    instagramController.dispose();
    cityController.dispose();
    provinceController.dispose();
    streetController.dispose();
    districtController.dispose();
    numberController.dispose();
    complementController.dispose();
    cepController.dispose();
    super.onClose();
  }

  callDialog(int step) => globalAlertDialog(
    title: (signUpStep.value == step)
        ? 'Você quer voltar à tela inicial de login?'
        : 'Não nos abandone :(',
    labelActionButton: 'SIM',
    colorOk: (signUpStep.value == step)
        ? colorSuccess : null,
    text: (signUpStep.value == step)
        ? null : 'Você quer cancelar o cadastro da sua conta no HeyJobs?',
    onPressedAction: () {
      if(signUpStep.value == step) {
        Get.offAllNamed(Routes.signIn);
      } else {
        deleteAccount();
      }
    },
  );
}
