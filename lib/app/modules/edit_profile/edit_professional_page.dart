import 'package:delivery_servicos/app/global/widgets/checkbox/custom_checkbox_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/core/values/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/expertises.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/textfields/text_field_widget.dart';
import 'controller/edit_controller.dart';
import 'widgets/edit_address_tab_form_widget.dart';
import 'widgets/edit_bottom_buttons_widget.dart';
import 'widgets/edit_personal_tab_form_widget.dart';
import 'widgets/edit_social_tab_form_widget.dart';
import 'widgets/edit_welcome_tab_widget.dart';

class EditProfessionalPage extends GetView<EditController> {
  EditProfessionalPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.callDialog();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => Visibility(
            visible: (controller.editStep.value < 5),
            child: const EditBottomButtonsWidget(),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar Perfil', style: TextStyle(color: appDarkGreyColor)),
          leading: IconButton(
            icon: Icon(Icons.close, color: appDarkGreyColor,),
            onPressed: () => controller.callDialog(),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Obx(() {
              if(controller.editStep.value < 5) {
                return SingleChildScrollViewWidget(
                  child: getFormByStep(controller.editStep.value, context),
                );
              } else {
                return const EditWelcomeTabWidget(type: 'Profissional');
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget getFormByStep(int step, BuildContext context) {
    if(step == 0) {
      return EditPersonalFormTabWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 1) {
      return EditAddressTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 2) {
      return ExpertisesFormWidget();
    } else if(step == 3) {
      return BioPaymentFormWidget();
    } else if(step == 4) {
      return EditSocialTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else {
      return const EditWelcomeTabWidget(type: 'Profissional');
    }
  }

  Widget ExpertisesFormWidget() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
        child: Column(
          children: [
            Text('Editar habilidades e serviços prestados',
                textAlign: TextAlign.justify,
                style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: defaultPadding16),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: 'Você tem novas ',
                style: appStyle.bodySmall,
                children: <TextSpan>[
                  TextSpan(text: 'habilidades ou serviços',
                    style: appStyle.bodySmall?.copyWith(
                        color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: ' que deseja realizar?',
                    style: appStyle.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding8),
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
        padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
        child: Column(
          children: [
            Text('Editar Formas de Pagamento',
                textAlign: TextAlign.justify,
                style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: defaultPadding16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Editar sua biografia e horários?',
                  textAlign: TextAlign.start,
                  style: appStyle.bodySmall),
            ),
            const SizedBox(height: defaultPadding16/2),
            TextFieldWidget(
                label: "Detalhes, horários e informações",
                type: TextInputType.text,
                minLines: 3,
                maxLines: 3,
                maxLength: 500,
                controller: controller.biographyController,
                validator: (String value) => null),
            Text('Teve alguma alteração em suas formas de pagamento?',
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
