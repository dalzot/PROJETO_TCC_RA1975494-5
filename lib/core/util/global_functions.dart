import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/modules/announce/controller/service_controller.dart';
import 'package:delivery_servicos/app/modules/edit_profile/controller/edit_controller.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_client_controller.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_controller.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_professional_controller.dart';
import 'package:delivery_servicos/app/modules/sign_in/controller/sign_in_controller.dart';
import 'package:delivery_servicos/core/values/expertises.dart';
import 'package:delivery_servicos/core/values/payment_methods.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:search_cep/search_cep.dart';

import '../../app/global/constants/constants.dart';
import '../../app/modules/chat/chat_details.dart';
import '../../app/modules/chat/controller/chat_controller.dart';
import '../../app/modules/profile/controller/profile_controller.dart';
import '../../app/modules/profile/models/profile_model.dart';
import '../services/firebase_service.dart';
import '../theme/app_color.dart';
import '../theme/app_style.dart';

// Singleton instance for app
final rxPrefs = RxSharedPreferences(
  SharedPreferences.getInstance(),
  kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
);

Future<SharedPreferences> prefs() async {
  return await SharedPreferences.getInstance();
}
// METHODS

bool validationCNPJ(String cnpjRaw) {
  String cnpj =
  cnpjRaw.replaceAll(".", "").replaceAll("-", "").replaceAll("/", "");
  int aux = 0;
  int v1 = 0;
  int v2 = 0;

  if (cnpj.length != 14 ||
      cnpj == "00000000000000" ||
      cnpj == "11111111111111" ||
      cnpj == "22222222222222" ||
      cnpj == "33333333333333" ||
      cnpj == "44444444444444" ||
      cnpj == "55555555555555" ||
      cnpj == "66666666666666" ||
      cnpj == "77777777777777" ||
      cnpj == "88888888888888" ||
      cnpj == "99999999999999") {
    return false;
  }

  for (var i = 0; i < 4; i++) {
    aux += int.parse(cnpj[i]) * (5 - i);
  }
  for (var i = 0; i < 8; i++) {
    aux += int.parse(cnpj[i + 4]) * (9 - i);
  }
  v1 = aux % 11;
  v1 = v1 < 2 ? 0 : 11 - v1;
  if (int.parse(cnpj[12]) != v1) return false;

  aux = 0;
  for (var i = 0; i < 5; i++) {
    aux += int.parse(cnpj[i]) * (6 - i);
  }
  for (var i = 0; i < 8; i++) {
    aux += int.parse(cnpj[i + 5]) * (9 - i);
  }
  v2 = aux % 11;
  v2 = v2 < 2 ? 0 : 11 - v2;
  if (int.parse(cnpj[13]) != v2) return false;

  return true;
}

bool validationCPF(String cpfRaw) {
  String cpf = cpfRaw.replaceAll(".", "").replaceAll("-", "");
  int aux = 0;
  int v1 = 0;
  int v2 = 0;

  if (cpf.length != 11 ||
      cpf == "00000000000" ||
      cpf == "11111111111" ||
      cpf == "22222222222" ||
      cpf == "33333333333" ||
      cpf == "44444444444" ||
      cpf == "55555555555" ||
      cpf == "66666666666" ||
      cpf == "77777777777" ||
      cpf == "88888888888" ||
      cpf == "99999999999") {
    return false;
  }

  for (var i = 0; i < 9; i++) {
    aux += int.parse(cpf[i]) * (10 - i);
  }
  v1 = (aux * 10) % 11;
  v1 = v1 == 10 ? 0 : v1;
  if (int.parse(cpf[9]) != v1) return false;

  aux = 0;
  for (var i = 0; i < 10; i++) {
    aux += int.parse(cpf[i]) * (11 - i);
  }
  v2 = (aux * 10) % 11;
  v2 = v2 == 10 ? 0 : v2;
  if (int.parse(cpf[10]) != v2) return false;
  return true;
}

String getMaskedZipCode(String zipCode) {
  MagicMask mask = MagicMask.buildMask('99999-999');
  return mask.getMaskedString(zipCode);
}

String getMaskedPhoneNumber(String phoneNumber) {
  if (phoneNumber.isEmpty || phoneNumber.length < 10) return '';
  if(phoneNumber.length >= 11) {
    return "(${phoneNumber.substring(0, 2)}) ${phoneNumber[2]} ${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}";
  } else if(phoneNumber.length >= 10) {
    return "(${phoneNumber.substring(0, 2)}) ${phoneNumber.substring(2, 6)}-${phoneNumber.substring(6)}";
  }
  return "(${phoneNumber.substring(0, 2)}) ${phoneNumber[2]} ${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}";
}

String getBlindedPhoneNumber(String phoneNumber) {
  String p = getRawPhoneNumber(phoneNumber);
  return "(${p.substring(0, 2)}) ${p[2]} ****-${p.substring(7)}";
}

String getRawPhoneNumber(String phoneNumber) {
  if (phoneNumber.isEmpty) return phoneNumber;
  return phoneNumber
      .replaceAll("(", "")
      .replaceAll(")", "")
      .replaceAll("-", "")
      .removeAllWhitespace;
}

String getRawZipCode(String zipCode) {
  if (zipCode.isEmpty) return zipCode;
  return zipCode.replaceAll('.', '').replaceAll('-', '');
}

String getRawDate(String date) {
  if (date.isEmpty) return date;
  return date.replaceAll('-', '').replaceAll('/', '').replaceAll(':', '').replaceAll(' ', '');
}

String getMaskedDocCPF(String docId, {bool isCNPJ = false}) {
  if (docId.isNotEmpty && docId.length < 11) {
    return isCNPJ
        ? 'CNPJ com formato inválido.'
        : 'CPF com formato inválido.';
  }
  if (docId.trim().length == 11) {
    return "${docId.substring(0, 3)}.${docId.substring(3, 6)}.${docId.substring(6, 9)}-${docId.substring(9, 11)}";
  } else if (docId.length == 14) {
    return "${docId.substring(0, 2)}.${docId.substring(2, 5)}.${docId.substring(5, 8)}/${docId.substring(8, 12)}-${docId.substring(12, 14)}";
  } else {
    return docId;
  }
}

String getMaskedDocRG(String docId) {
  if (docId.trim().length == 7) {
    return "${docId.substring(0, 1)}.${docId.substring(1, 4)}.${docId.substring(4, 7)}";
  } else if (docId.trim().length > 7) {
    return "${docId.substring(0, 1)}.${docId.substring(1, 4)}.${docId.substring(4, 7)}-${docId.substring(7)}";
  } else {
    return docId;
  }
}

String getMaskedRGEmit(String emit) {
  if (emit.trim().length == 5) {
    return "${emit.substring(0, 3)}/${emit.substring(3)}";
  } else {
    return emit;
  }
}

snackBar(String message, {Color? color, Duration? duration}) {
  return Get.snackbar(message, '',
      messageText: Visibility(
        visible: false,
        child: Container(),
      ),
      titleText: Text(message,
          style: Get.textTheme.bodyText2!.copyWith(color: appWhiteColor)),
      backgroundColor: color ?? Colors.black.withOpacity(.87),
      colorText: appWhiteColor,
      borderRadius: 0,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
      duration: duration ?? const Duration(seconds: 3),
      barBlur: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16));
}

Future globalAlertDialog(
    {required String title,
      required String labelActionButton,
      required void Function() onPressedAction,
      String? text,
      Widget? child,
    Color? colorOk}) {
  const String labelBackButton = 'voltar';
  return Get.dialog(
    AlertDialog(
        title: Text(title,
          style: Get.textTheme.titleSmall),
        content: child ?? (text != null ? SingleChildScrollViewWidget(
          child: Text(text,
            style: Get.textTheme.bodyMedium),
        ) : null),
        actions: [
          Visibility(
            visible: labelActionButton != 'entendi' && labelActionButton != 'ok',
            child: TextButton(
              child: Text(
                labelBackButton.toUpperCase(),
                style: AppStyle()
                    .appTextThemeLight
                    .labelLarge!
                    .copyWith(color: appDarkGreyColor),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          TextButton(
            onPressed: onPressedAction,
            child: Text(
              labelActionButton.toUpperCase(),
              style: AppStyle()
                  .appTextThemeLight
                  .labelLarge!
                  .copyWith(
                  color: colorOk ?? (labelActionButton == 'entendi'
                      ? appDarkGreyColor : labelActionButton == 'ok'
                      ? appLightPrimaryColor : appNormalDangerColor)),
            ),
          )
        ]),
    barrierDismissible: false,
  );
}

String dateFormat(DateTime date, {bool needYear = true}) => needYear
    ? DateFormat('dd/MM/yyyy').format(date)
    : DateFormat('dd/MM').format(date);

String dateTimeFormat(DateTime date) => DateFormat('dd/MM/yyyy HH:mm:ss').format(date);

String timeFormat(DateTime schedule) => DateFormat('HH:mm').format(schedule);

String dateToString(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

String stringFromDateString(String param) {
  List<String> d = param.contains('-') ? param.split('-') : param.split('/');
  if(d.length < 2) return param;

  return dateFormat(d[0].length == 4
      ? DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]))
      : DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0])));
}

String dateNowString() => dateTimeFormat(DateTime.now());

DateTime dateFromString(String param) {
  List<String> d = param.contains('-') ? param.split('-') : param.split('/');
  DateTime date = d[0].length == 4
      ? DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]))
      : DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]));
  return date;
}

DateTime dateTimeFromString(String param) {
  List<String> dateTimes = param.split(' ');
  List<String> d = dateTimes[0].split('/');
  List<String> h = dateTimes[1].split(':');
  DateTime date = DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]),
      int.parse(h[0]), int.parse(h[1]), int.parse(h[2]));
  return date;
}

String dateTimeAt(String date, {levelOfPrecision = 1}) {
  String at = DateTimeFormat.relative(dateTimeFromString(date),
      abbr: true, levelOfPrecision: levelOfPrecision, ifNow: 'Agora');
  return at.replaceAll('w', 's');
}

bool compareDateFromNow(String param) {
  List<String> d = param.contains('-') ? param.split('-') : param.split('/');
  DateTime date = d[0].length == 4
      ? DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]))
      : DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]));
  return date
      .isAfter(DateTime.now().subtract(const Duration(days: 365*18)));
}

Future getAddressByCEP(String cep) async {
  final searchCep = ViaCepSearchCep();
  final infoCep = await searchCep.searchInfoByCep(cep: cep);
  return infoCep.fold(
    (l) => l,
    (r) => r,
  );
}

bool checkUserType(String type) {
  return type.toLowerCase() == 'profissional';
}

// ACCESS
logout() async {
  SignInController signInController = Get.find<SignInController>();
  signInController.logout();

//  HomeController().dispose();
//  HomeClientController().dispose();
//  HomeProfessionalController().dispose();
//  ChatController().dispose();
//  EditController().dispose();
//  ServiceController().dispose();
//  ProfileController().dispose();
}

Future globalFunctionOpenChat({ProfileModel? profileParam, String? profileId, String? chatId}) async {
  ProfileModel? profile;
  if(profileParam == null && profileId != null && profileId.isNotEmpty) {
    profile = await FirebaseService.getProfileModelData(profileId);
  } else {
    profile = profileParam;
  }
  if(profile != null) {
    Get.lazyPut(()=>ChatController());
    ChatController chatController = Get.find<ChatController>();
    chatController.setSelectedChatProfile(profile, chatId);
    Get.to(() => ChatDetailsPage(profile: profile!));
  } else {
    snackBar('Não foi possível encontrar o usuário');
  }
}

// RANDOM TESTS
List<String> auxNamesList = [
  "Bruna", "Débora", "Sabrina", "Michael", "Caetano", "Helena", "Clara", "Olívia", "Marina",
  "João Pedro", "Marina", "Maria Fernanda", "Ágata", "João Miguel", "Yuri", "Agnes", "Davi",
  "Fernando", "Aquiles", "Juliano", "Luiza", "Beatriz", "Laila", "Melinda", "Dulce", "Clara",
  "Camila", "Matheus", "Benjamin", "Cristiano"];
List<String> auxCepsList = [
  '89167480', '88806596', '77001493', '36772018', '21930040', '77458970', '81470060', '73365058',
  '58080640', '06310140', '54505470', '69309201', '45604675', '87202350', '69900505', '29936825',
];
List<String> auxCPFsList = [
  '01468757024', '42273918062', '87694479000', '82909014029', '28443306068', '04138434089',
  '06491059073', '13584796075', '53458163018', '27503626011', '88071731072', '05721358076'
];
List<String> auxRGFsList = [
  '132636967', '166409522', '136605977', '172758695', '149741728', '195947654', '274466545',
  '215180392', '284570953', '399701060', '438943624', '290882357', '169332251', '417675276',
];

generateRandom(int type) async {
  var random = Random.secure();

  for(int i = 0; i < 10; i++) {
    var firebaseId = base64Encode(List<int>.generate(12, (i) =>  random.nextInt(255)));
    var nome = auxNamesList[Random().nextInt(auxNamesList.length - 1)];
    var cpf = auxCPFsList[Random().nextInt(auxCPFsList.length - 1)];
    var rg = auxRGFsList[Random().nextInt(auxRGFsList.length - 1)];

    String cep = '89820000', bairro = 'Centro',
        cidade = 'Xanxerê', uf = 'SC',
        logradouro = 'Av. Brasil', numero = '123';
    final cepFounded = await getAddressByCEP(auxCepsList[Random().nextInt(auxCepsList.length - 1)]);
    if(cepFounded is ViaCepInfo) {
      cep = cepFounded.cep!;
      bairro = cepFounded.bairro!;
      cidade = cepFounded.localidade!;
      uf = cepFounded.uf!;
      logradouro = cepFounded.logradouro!;
      numero = cepFounded.unidade ?? '123';
    }

    ProfileModel profileData = ProfileModel(
        firebaseId: firebaseId,
        name: nome,
        docCpf: cpf,
        docRg: rg,
        docRgEmit: 'sspsc',
        dateBirthday: '01/01/2000',
        phoneNumber: '49999999999',
        phoneNumber2: '4733223322',
        biographyDetails: '',
        otherPayments: '',
        paymentMethods: [allPaymentMethods[0], allPaymentMethods[2]],
        email: 'testeauxiliar@teste.com',
        password: '123456789',
        facebook: nome,
        instagram: nome,
        linkedin: nome,
        telegram: nome,
        whatsapp: '49999999999',
        addressStreet: logradouro,
        addressNumber: numero,
        addressComplement: '',
        addressCity: cidade,
        addressProvince: uf,
        addressDistrict: bairro,
        addressCEP: cep,
        addressLatGPS: '',
        addressLngGPS: '',
        status: 'offline',
        showFullName: false,
        showFullAddress: false,
        rate: 0.0,
        qtdRequests: 0,
        totalRequests: 0.0,
        dateUpdated: dateNowString(),
        dateCreated: dateNowString(),
        dateLastView: dateNowString()
    );
    if(type == 1) { // Profissionais
      profileData.profileType = 'profissional';
      profileData.expertises = [allExpertises[0]['value'][0], allExpertises[0]['value'][2], allExpertises[0]['value'][3]];
      await FirebaseFirestore.instance
          .collection(collectionProfiles).doc(profileData.firebaseId)
          .set(profileData.toJson());
    } else { // Clientes
      profileData.profileType = 'cliente';
      await FirebaseFirestore.instance
          .collection(collectionProfiles).doc(profileData.firebaseId)
          .set(profileData.toJson());
    }
  }
}

