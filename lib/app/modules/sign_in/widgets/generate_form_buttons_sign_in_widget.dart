import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/action_button_widget.dart';
import '../../../global/widgets/buttons/social_media_button_widget.dart';
import '../controller/sign_in_controller.dart';

class GenerateFormButtonsSignInWidget extends StatelessWidget {
  final SignInController controller;
  const GenerateFormButtonsSignInWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    controller.clearFields();
                    Get.toNamed(Routes.forgotPassword);
                  },
                  child: const Text("Esqueci minha senha"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ActionButtonWidget(
                title: "ENTRAR",
                function: (controller.isFormValidated.value)
                    ? () => controller.submitForm()
                    : null,
              ),
            ),
//            const SizedBox(height: defaultPadding),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
////                Flexible(
////                  child: SocialMediaButtonWidget(
////                    key: const Key("btn-sm-facebook-signin"),
////                    title: "FACEBOOK",
////                    imagePath: 'assets/icons/f-facebook.png',
////                    bgColor: colorFacebook,
////                    function: () => controller.signInWithFacebook(),
////                  ),
////                ),
////                Flexible(
////                  child: Row(
////                    mainAxisAlignment: MainAxisAlignment.center,
////                    children: [
////                      Text(
////                        "Ou acesse com o ",
////                        style: fontStyleBody1.copyWith(color: colorGrey[500]),
////                      ),
////                      SocialMediaButtonWidget(
//////                      title: "GOOGLE",
////                          imagePath: 'assets/icons/google.png',
//////                      bgColor: colorGoogle,
////                          function: () async {
////                            controller.signInWithGoogle();
////                          }),
////                    ],
////                  ),
////                ),
//              ],
//            ),
//            Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Visibility(
//                  visible: Platform.isIOS,
//                  replacement: const Spacer(),
//                  child: SocialMediaButtonWidget(
//                      key: const Key("btn-sm-appl-signin"),
//                      title: "APPLE",
//                      imagePath: 'assets/icons/apple_logo.png',
//                      bgColor: colorApple,
//                      function: () async {
//                        controller.signInWithApple((String accessToken) {
//                          dataSourceApi
//                              .loginGoogle(accessToken)
//                              .then((response) async {
//                            if (response.statusCode == 200) {
//                              Map<String, dynamic> decodedJson =
//                                  jsonDecode(response.data);
//
//                              UserModel user = UserModel.fromJson(
//                                  decodedJson['user']);
//                              int lastInsertedId = 0;//await UserProvider().insertOrUpdate(user);
//                              final p = await prefs();
//                              p.setString(jwtToken, decodedJson['token'] ?? "0");
//                              p.setInt(userId, lastInsertedId);
//                              Get.offAndToNamed(Routes.home);
//                            } else {
//                              snackBar("Usuário não encontrado.");
//                            }
//                          });
//                        });
//                      }),
//                ),
//              ],
//            ),
          ],
        ));
  }
}
