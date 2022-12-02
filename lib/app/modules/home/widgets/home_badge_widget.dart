import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class HomeBadgeWidget extends GetView<HomeController> {
  const HomeBadgeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
//      child: InkWell(
//        onTap: () {
//          Get.toNamed(Routes.notifications);
//        },
//        child: Obx(
//          () => Badge(
//            showBadge:
//                controller.notificationService.numberNewNotifications.value == 0
//                    ? false
//                    : true,
//            badgeColor: appNormalDangerColor,
//            position: BadgePosition.topEnd(top: 4, end: 0),
//            badgeContent: Text(
//              controller.notificationService.numberNewNotifications.value
//                  .toString(),
//              style: Theme.of(context).textTheme.bodyText2?.copyWith(
//                    color: Colors.white,
//                  ),
//            ),
//            child: const Icon(
//              Icons.notifications_none,
//              size: 30,
//            ),
//          ),
//        ),
//      ),
    );
  }
}
