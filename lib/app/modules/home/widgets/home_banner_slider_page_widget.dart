//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//
//import '../../../core/services/auth_service.dart';
//import '../../../core/theme/app_color.dart';
//import '../controller/home_controller.dart';
//import 'home_banner_slider_page_view_navigator.dart';
//
//class HomeBannerSliderPageWidget extends GetView<HomeController> {
//  final int initialPage;
//  HomeBannerSliderPageWidget({Key? key, this.initialPage = 0})
//      : super(key: key);
//
//  final List<Widget> _pages = [];
//
//  @override
//  Widget build(BuildContext context) {
////    final name = Get.find<AuthServices>().user.name;
//    _pages.clear();
//    _pages.addAll([
//      _SliderPageChildContentWidget(
//        imageAssetPath: 'assets/slide/money-banner.png',
//        title: "Vendeu, ganhou!",
//        text:
//            "Ganhe até 2% de cashback para usar\ncomo crédito nas compras na Cassol.\n\nQuanto mais produtos vender, mais cashback você pode ganhar.",
//        whatsappMessage:
//            "Olá, tudo bem?\n\nMeu nome é  e sou profissional parceiro da Cassol.\n\nEu gostaria de ter *mais informações* sobre *cashback* 💰, por favor.",
//      ),
//      _SliderPageChildContentWidget(
//        imageAssetPath: 'assets/slide/motorcycle-banner.png',
//        title: "Entrega expressa",
//        text:
//            "Faça seu pedido até às 18h para\nreceber no mesmo dia.\n\nAté 20 Kg de produtos,\nvocê recebe em duas horas!",
//        whatsappMessage:
//            "Olá, tudo bem?\n\nMeu nome é  e sou profissional parceiro da Cassol.\n\nEu gostaria de ter *mais informações* sobre *entrega* 🚚, por favor.",
//      ),
//      _SliderPageChildContentWidget(
//        imageAssetPath: 'assets/slide/pack-banner.png',
//        title: "Precisou, achou!",
//        text:
//            "Mais de 30 mil produtos\na pronta entrega pra você.\n\nAgilidade no atendimento com\nsuporte do Especialista PRO.",
//        whatsappMessage:
//            "Olá, tudo bem?\n\nMeu nome é  e sou profissional parceiro da Cassol.\n\nEu gostaria de ter *mais informações* sobre *busca de produtos* 🔎📦, por favor.",
//      ),
//    ]);
//    controller.sliderPageController = PageController(initialPage: initialPage);
//    controller.sliderActualPage.value = initialPage;
//
//    return Material(
//      child: Container(
//        alignment: Alignment.center,
//        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//        color: appWhiteColor,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: [
//            SizedBox(
//              height: Get.height * 0.1,
//              child: Container(
//                padding: const EdgeInsets.symmetric(vertical: 12),
//                alignment: Alignment.topLeft,
//                child: TextButton.icon(
//                  onPressed: () => Get.back(),
//                  icon: const Icon(
//                    Icons.close,
//                    color: appDarkGreyColor,
//                  ),
//                  label: const Text(""),
//                ),
//              ),
//            ),
//            SizedBox(
//              height: Get.height * 0.8,
//              child: PageView(
//                pageSnapping: false,
//                physics: const NeverScrollableScrollPhysics(),
//                controller: controller.sliderPageController,
//                children: _pages,
//              ),
//            ),
//            SizedBox(
//              height: Get.height * 0.07,
//              child: HomeBannerSliderPageViewNavigatorWidget(pages: _pages),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class _SliderPageChildContentWidget extends GetView<HomeController> {
//  final String imageAssetPath;
//  final String title;
//  final String text;
//  final String whatsappMessage;
//  const _SliderPageChildContentWidget({
//    Key? key,
//    required this.imageAssetPath,
//    required this.title,
//    required this.text,
//    this.whatsappMessage = "",
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      alignment: Alignment.topCenter,
//      padding: const EdgeInsets.symmetric(horizontal: 12),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          SizedBox(
//            height: Get.height * 0.4,
//            child: Image.asset(
//              imageAssetPath,
//              fit: BoxFit.contain,
//            ),
//          ),
//          const SizedBox(
//            height: 24,
//          ),
//          Center(
//            child: Text(
//              title,
//              style: Get.textTheme.headline6,
//            ),
//          ),
//          const SizedBox(
//            height: 16,
//          ),
//          Center(
//            child: Text(
//              text,
//              style: Get.textTheme.bodyText1,
//              textAlign: TextAlign.center,
//            ),
//          ),
//          const SizedBox(
//            height: 24,
//          ),
//          Center(
//            child: OutlinedButton(
//              onPressed: () {
//                Get.back();
////                SendWhatsappMessage()
////                    .sendMessage(cassolPhoneNumber, message: whatsappMessage);
//              },
//              style: ButtonStyle(
//                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
//                  horizontal: 24,
//                  vertical: 12,
//                )),
//                side: MaterialStateProperty.resolveWith<BorderSide>(
//                  (Set<MaterialState> states) =>
//                      const BorderSide(color: appNormalPrimaryColor, width: 1),
//                ),
//              ),
//              child: Text(
//                "QUERO SABER MAIS",
//                style: Get.textTheme.button?.copyWith(
//                  color: appNormalPrimaryColor,
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
