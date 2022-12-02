//import 'package:dots_indicator/dots_indicator.dart';
//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//
//import '../../../../core/theme/app_color.dart';
//import '../controller/home_controller.dart';
//
//class HomeBannerSliderPageViewNavigatorWidget extends GetView<HomeController> {
//  final List<Widget> pages;
//
//  const HomeBannerSliderPageViewNavigatorWidget({Key? key, required this.pages})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Obx(
//      () => Container(
//        alignment: Alignment.center,
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            SizedBox(
//              width: Get.width * 0.2,
//              child: Visibility(
//                visible: true,
//                child: TextButton.icon(
//                  style: ButtonStyle(
//                    overlayColor: MaterialStateProperty.all<Color>(
//                        appDarkGreyColor.withAlpha(20)),
//                  ),
//                  onPressed: () {
//
//                  },
//                  icon: const Icon(
//                    Icons.arrow_back_ios_rounded,
//                    color: appDarkGreyColor,
//                    size: 14,
//                  ),
//                  label: const Text(""),
//                ),
//              ),
//            ),
//            SizedBox(
//              width: Get.width * 0.2,
//              child: DotsIndicator(
//                dotsCount: pages.length,
//                position: controller.sliderActualPage.value.toDouble(),
//                decorator: DotsDecorator(
//                  color: appDarkGreyColor.withOpacity(0.5), // Inactive color
//                  activeColor: appDarkGreyColor,
//                ),
//              ),
//            ),
//            SizedBox(
//              width: Get.width * 0.2,
//              child: Visibility(
//                visible: controller.sliderActualPage.value < (pages.length - 1),
//                child: TextButton.icon(
//                  style: ButtonStyle(
//                    overlayColor: MaterialStateProperty.all<Color>(
//                        appDarkGreyColor.withAlpha(20)),
//                  ),
//                  onPressed: () {
//                    changePage(controller.sliderActualPage.value + 1);
//                  },
//                  icon: const Text(""),
//                  label: const Icon(
//                    Icons.arrow_forward_ios_outlined,
//                    color: appDarkGreyColor,
//                    size: 14,
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  changePage(int pageIndex) {
//    if (pageIndex < 0) pageIndex = 0;
//    controller.sliderActualPage.value = pageIndex;
//    controller.sliderPageController.animateToPage(
//      pageIndex,
//      curve: Curves.easeIn,
//      duration: const Duration(milliseconds: 300),
//    );
//  }
//}
