import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';

import '../../../global/constants/constants.dart';

class CheckVersionPage extends StatelessWidget {
  const CheckVersionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
//                    Image.asset('assets/images/undraw_update.png',
//                        fit: BoxFit.cover, height: 220),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Text('Atualização disponível',
                          style: Get.textTheme.headline6),
                    ),
                    Text(
                      'Uma nova versão do aplicativo está disponível. Por favor, atualize.',
                      style: Get.textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'É muito importante atualizar, manter uma versão desatualizada pode ocasionar instabilidades.',
                      style: Get.textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                height: 36,
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () async {
                    OpenStore.instance.open(
                      //appStoreId: '6443602859',
                      androidAppBundleId: appPackageName,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8)),
                  child: Visibility(
                    visible: true,
                    replacement: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )),
                    child: Text(
                      'Atualizar agora'.toUpperCase(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
