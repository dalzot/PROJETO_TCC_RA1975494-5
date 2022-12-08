import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/constants/styles_const.dart';
import 'package:delivery_servicos/app/global/widgets/body/global_list_view_widget.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/body/custom_scaffold.dart';
import 'controller/about_controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: CustomScaffold(
          showBottomMenu: false,
          pageTitle: 'Sobre',
          body: Padding(
            padding: globalPadding32,
            child: GlobalListViewWidget(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('O desenvolvedor', style: appStyle.titleLarge),
                  ],
                ),
                const Divider(height: 32, thickness: 2, color: appLightGreyColor),
                Subtitle('Quem sou eu?'),
                DefaultText('Olá, me chamo Matheus e sou acadêmico do curso de BACHARELADO EM ENGENHARIA DE SOFTWARE '
                    'pela universidade Unicesumar, resido na cidade de Xanxerê em Santa Catarina, sou programador a '
                    'mais de 10 anos, no mundo mobile a mais de 5 anos.\n'
                    'Desenvolvi esse projeto para o meu TCC, porém, pretendo dar continuidade nele e torná-lo uma '
                    'ferramenta real e pública, com o intuito de ajudar com que profissionais qualificados possam '
                    'ter uma nova fonte de renda e uma área de atuação mais ampla com a ajuda do app para conectar-se '
                    'a novos potenciais clientes.'),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('O aplicativo', style: appStyle.titleLarge),
                    ],
                  ),
                ),
                const Divider(height: 32, thickness: 2, color: appLightGreyColor),
                Subtitle('Estágio do aplicativo'),
                DefaultText('Por se tratar de uma aplicação para o TCC, ela ainda está bem crua, posso dizer que é um '
                    'simples MVP relacionado ao produto o qual eu quero desenvolver de fato. Após o término do curso, '
                    'darei continuidade, melhorando e otimizando a área do servidor de dados e também a parte visual, '
                    'por se tratar de um MVP, ainda tem muitos ajustes que precisam ser realizados, otimização das '
                    'listas, telas de perfil, telas de serviços e várias outras implementações futuras.'),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Subtitle('Ideia do projeto'),
                ),
                DefaultText('A ideia desse projeto, veio por meio da falta de uma ferramenta simples e objetiva, '
                    'onde o intuito principal seja auxiliar as pessoas a encontrarem bons profissionais com '
                    'base em suas qualificações e avaliações. Aqui no HeyJobs, os profissionais podem encontrar '
                    'novos clientes para aumentarem suas fontes de renda, bem como os clientes podem econtrar '
                    'profissionais qualificados para realizarem seus serviços.'),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Subtitle('Desenvolvimento'),
                ),
                DefaultText('O aplicativo foi desenvolvido utilizando o método de Clean Architecture, com estruturação '
                    'modular, onde cada módulo é separado e organizado devido suas funções e classes. Utilizando a lib '
                    'Getx para gerenciamento de estado, conseguimos otimizar todo o projeto, de modo que apenas os '
                    'widgets/componentes visuais que precisam ser atualizados, serão atualizados, evitando que cada vez '
                    'que uma informação seja alterada, o app atualize toda a árvore de widgets novamente sem necessidade.'),
              ],
            ),
          )
      ),
    );
  }

  Widget Subtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(subtitle,
        style: appStyle.titleSmall,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget DefaultText(String text) {
    return Text(text,
      style: appStyle.bodySmall,
      textAlign: TextAlign.justify,
    );
  }
}
