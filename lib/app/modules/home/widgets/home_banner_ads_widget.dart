import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBannerAdsWidget extends StatelessWidget {
  const HomeBannerAdsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 72,
      decoration: BoxDecoration(
        color: appDarkPrimaryColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Torne-se um profissional de destaque',
                  softWrap: true,
                  maxLines: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(Icons.open_in_new_rounded, color: appNormalPrimaryColor,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
