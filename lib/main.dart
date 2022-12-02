import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl_standalone.dart';

import 'app/global/notification/custom_firebase_messaging.dart';
import 'core/initial_binding/initial_binding.dart';
import 'core/theme/app_color.dart';
import 'core/theme/app_theme.dart';
import 'core/util/print_exception.dart';
import 'certification_http.dart';
import 'core/values/firebase_config.dart';
import 'routes/app_pages.dart';

void main() {
  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = MyHttpOverrides();

      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: appDarkPrimaryColor,
      ));

      if (Firebase.apps.isNotEmpty) {
        await Firebase.initializeApp(
            options: DefaultFirebaseConfig.platformOptions);
      } else {
        await Firebase.initializeApp();
        Firebase.app(); // if already initialized, use that one

      }
      await CustomFirebaseMessaging().inicialize();

      findSystemLocale().then(
            (_) => runApp(
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.initial,
            initialBinding: InitialBinding(),
            theme: AppTheme().appThemeDataLight,
            darkTheme: AppTheme().appThemeDataLight,
            defaultTransition: Transition.fadeIn,
            getPages: AppPages.routes,
            locale: const Locale('pt', 'BR'),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              Locale('pt', 'BR'),
            ],
          ),
        ),
      );
    },
    (error, stack) => printException('App', error, stack),
  );
}