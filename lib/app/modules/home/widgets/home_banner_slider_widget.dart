import 'package:carousel_slider/carousel_slider.dart';
import '/app/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/styles_const.dart';
import '../../profile/widgets/professional_card_widget.dart';

class HomeBannerProfessionalWidget extends GetView<HomeController> {
  const HomeBannerProfessionalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CarouselSlider(
          items: [].map((detach) {
            return Builder(
              builder: (BuildContext context) {
                return ProfessionalCardWidget(profile: detach);
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 168,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 1200),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  Widget IconRating(i) {
    IconData icon = i == 3 ? Icons.star_half_rounded
        : i > 3 ? Icons.star_border_rounded
        : Icons.star_rounded;
    Color color = i == 3 ? colorWarning
        : i > 3 ? appNormalGreyColor
        : colorWarning;

    return Icon(icon, color: color);
  }
}
