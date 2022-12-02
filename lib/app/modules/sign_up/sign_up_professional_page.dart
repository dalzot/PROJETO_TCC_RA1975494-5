import 'package:delivery_servicos/app/global/widgets/checkbox/custom_checkbox_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/modules/sign_up/widgets/welcome_tab_widget.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/core/values/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/values/expertises.dart';
import '../../../routes/app_pages.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/textfields/text_field_widget.dart';
import 'controller/sign_up_controller.dart';
import 'widgets/address_tab_form_widget.dart';
import 'widgets/bottom_buttons_widget.dart';
import 'widgets/personal_tab_form_widget.dart';
import 'widgets/social_tab_form_widget.dart';
import 'widgets/type_account_widget.dart';

class SignUpProfessionalPage extends GetView<SignUpController> {
  SignUpProfessionalPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.callDialog(5);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => Visibility(
            visible: (controller.signUpStep.value < 5),
            child: const BottomButtonsWidget(),
          ),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Obx(() {
              if(controller.signUpStep.value < 5) {
                return SingleChildScrollViewWidget(
                  child: getFormByStep(controller.signUpStep.value, context),
                );
              } else {
                return const WelcomeTabWidget(type: 'Profissional');
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget getFormByStep(int step, BuildContext context) {
    if(step == 0) {
      return PersonalFormTabWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 1) {
      return AddressTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 2) {
      return ExpertisesFormWidget();
    } else if(step == 3) {
      return BioPaymentFormWidget();
    } else if(step == 4) {
      return SocialTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else {
      return const WelcomeTabWidget(type: 'Profissional');
    }
  }

  Widget ExpertisesFormWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding16 / 2, vertical: defaultPadding16),
        child: Column(
          children: [
            const SizedBox(height: defaultPadding16),
            Text('Escolha os serviços que você atenderá pelo aplicativo',
                textAlign: TextAlign.justify,
                style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: defaultPadding16/2),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: 'Vamos lá, estamos quase acabando, agora precisamos definir quais são as suas ',
                style: appStyle.bodySmall,
                children: <TextSpan>[
                  TextSpan(text: 'habilidades & serviços prestados',
                    style: appStyle.bodySmall?.copyWith(
                        color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: '.\nVocê poderá adicionar ou remover alguma especialização no futuro, conforme suas qualificações.',
                    style: appStyle.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding16),
            const Divider(thickness: 2, height: defaultPadding16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selecione os serviços prestados:', style: appStyle.bodySmall,),
                GlobalListViewBuilderWidget(
                    itemCount: allExpertises.length,
                    itemBuilder: (_, index) {
                      var expertise = allExpertises[index];
                      var subExpertises = expertise['value'];
                      return CustomCheckboxWidget(
                        onCheck: (checked) => controller.addProfessionalExpertises(expertise: checked),
                        onUncheck: (unchecked) => controller.removeProfessionalExpertises(expertise: unchecked),
                        parent: Text(expertise['title']),
                        checkList: controller.profileExpertises,
                        children: subExpertises.map((e) =>
                            Text(e.toString())).toList());
                    }),
              ],
            ),
            const Divider(thickness: 2, height: defaultPadding16,),
            const SizedBox(height: defaultPadding16),
            Text('Lembre-se de escolher apenas os serviços os quais você consegue realizar, '
                'sua reputação no app dependerá da qualidade do serviço prestado e das avaliações de seus clientes.',
              textAlign: TextAlign.justify,
              style: appStyle.bodySmall),
            const SizedBox(height: defaultPadding16),

          ],
        )
    );
  }

  Widget BioPaymentFormWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding16 / 2, vertical: defaultPadding16),
        child: Column(
          children: [
            const SizedBox(height: defaultPadding16),
            Text('Muito bem, estamos quase na etapa final!',
                textAlign: TextAlign.justify,
                style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: defaultPadding16/2),
            Text('Agora nos conte um pouco mais sobre sua biografia e os '
                'mais detalhes do seu trabalho se assim preferir.',
                textAlign: TextAlign.justify,
                style: appStyle.bodySmall),
            const SizedBox(height: defaultPadding16/2),
            TextFieldWidget(
                label: "Detalhes, horários e informações",
                type: TextInputType.text,
                minLines: 3,
                maxLines: 3,
                maxLength: 500,
                controller: controller.biographyController,
                validator: (String value) => null),
            Text('Precisamos definir também, quais serão as formas de pagamento que você aceita, '
                'você poderá atualizar essas informações no futuro também.',
                textAlign: TextAlign.justify,
                style: appStyle.bodySmall),
            const SizedBox(height: defaultPadding16),
            const Divider(thickness: 2, height: defaultPadding16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selecione as formas de pagamento que você aceita:', style: appStyle.bodySmall,),
                GlobalListViewBuilderWidget(
                    itemCount: 1,
                    itemBuilder: (_, index) {
                      return CustomCheckbox(
                          onCheck: (checked) => controller.addPaymentsMethods(
                              payment: checked, form: _formKey.currentState),
                          onUncheck: (unchecked) => controller.removePaymentsMethods(
                              payment: unchecked, form: _formKey.currentState),
                          checkList: controller.paymentMethods,
                          children: allPaymentMethods.map((e) =>
                              Text(e.toString())).toList());
                    }),
              ],
            ),
            const Divider(thickness: 2, height: defaultPadding16,),
            TextFieldWidget(
                label: "Outros métodos de pagamento",
                type: TextInputType.text,
                minLines: 2,
                maxLines: 2,
                controller: controller.otherPaymentsController,
                validator: (String value) => null),
            Text('Não se preocupe, o app não realizará nenhuma cobrança e '
                'não aceitará nenhum pagamento como intermediário, as formas '
                'de pagamento escolhidas, serão mostradas aos clientes para que '
                'saibam quais as maneiras você aceitará como pagamento.',
              textAlign: TextAlign.justify,
              style: appStyle.bodySmall),
            const SizedBox(height: defaultPadding16/2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('IMPORTANTE',
                textAlign: TextAlign.start,
                style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            ),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: 'O aplicativo é ',
                style: appStyle.bodySmall,
                children: <TextSpan>[
                  TextSpan(text: '100% GRATUITO',
                    style: appStyle.bodySmall?.copyWith(
                        color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: ', você é livre para criar anúncios e '
                      'aceitar chamados de serviços, não cobramos comissão nem taxas de anúncio',
                    style: appStyle.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding16),
          ],
        )
    );
  }
}
