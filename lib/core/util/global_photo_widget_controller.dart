import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalPhotoWidgetController extends GetxController {
  RxInt current = 0.obs;

  @override
  void onClose() {
    super.onDelete.call();
    super.onClose();
  }

  showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const Spacer(),
              CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
