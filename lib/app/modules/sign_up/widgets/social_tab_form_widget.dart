import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';
import '../controller/sign_up_controller.dart';

class SocialTabFormWidget extends StatelessWidget {
  final SignUpController controller;
  final GlobalKey<FormState> formKey;
  const SocialTabFormWidget({
    required this.controller,
    required this.formKey,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding16),
        Text('Quer atrair mais público para suas redes sociais?',
            textAlign: TextAlign.justify,
            style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: defaultPadding16/2),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: 'Chegamos na etapa final e aqui você poderá compartilhar suas ',
            style: appStyle.bodySmall,
            children: <TextSpan>[
              TextSpan(text: 'redes sociais',
                style: appStyle.bodySmall?.copyWith(
                    color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
              ),
              TextSpan(text: ' se preferir.\nSe sim, insira abaixo os contatos para suas redes sociais.',
                style: appStyle.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding16/2),
        TextFieldWidget(
            label: "Whatsapp",
            hintText: '(49) 9 1234-1234',
            type: const TextInputType.numberWithOptions(),
            controller: controller.whatsappController,
            iconFa: const FaIcon(FontAwesomeIcons.whatsapp),
            inputFormatter: [
              maskFormatterPhone,
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: (String value) => null),
        TextFieldWidget(
            label: "Telegram",
            hintText: '@HeyJobs',
            controller: controller.telegramController,
            type: TextInputType.text,
            iconFa: const FaIcon(FontAwesomeIcons.telegramPlane),
            inputFormatter: [
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: (String value) => null),
        TextFieldWidget(
            label: "Instagram",
            hintText: '@heyjobs.app',
            type: TextInputType.text,
            controller: controller.instagramController,
            iconFa: const FaIcon(FontAwesomeIcons.instagram),
            inputFormatter: [
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: (String value) => null),
        TextFieldWidget(
            label: "Facebook",
            hintText: '/heyjobs',
            type: TextInputType.text,
            controller: controller.facebookController,
            iconFa: const FaIcon(FontAwesomeIcons.facebookF),
            inputFormatter: [
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: (String value) => null),
        TextFieldWidget(
            label: "Linkedin",
            hintText: '/heyjobs',
            type: TextInputType.text,
            controller: controller.linkedinController,
            iconFa: const FaIcon(FontAwesomeIcons.linkedinIn),
            inputFormatter: [
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: (String value) => null),
        const SizedBox(height: defaultPadding16),
        Text('Se você preferir, poderá adicionar suas redes sociais depois em seu perfil.',
            textAlign: TextAlign.justify,
            style: appStyle.bodySmall),
        const SizedBox(height: defaultPadding16),

      ],
    );
  }
}
