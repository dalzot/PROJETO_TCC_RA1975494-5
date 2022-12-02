import 'package:firebase_messaging/firebase_messaging.dart';
import 'custom_local_notification.dart';

class CustomFirebaseMessaging {
  final CustomLocalNotification _customLocalNotification;

  CustomFirebaseMessaging._internal(this._customLocalNotification);
  static final CustomFirebaseMessaging _singleton =
      CustomFirebaseMessaging._internal(CustomLocalNotification());
  factory CustomFirebaseMessaging() => _singleton;

  Future<void> inicialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      AppleNotification? apple = notification?.apple;

      if (notification != null && android != null) {
        _customLocalNotification.androidNotification(notification, android);
      }

      if (notification != null && apple != null) {
        _customLocalNotification.appleNotification(notification, apple);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      AppleNotification? apple = notification?.apple;

      if (notification != null && android != null) {
        _customLocalNotification.androidNotification(notification, android);
      }

      if (notification != null && apple != null) {
        _customLocalNotification.appleNotification(notification, apple);
      }
    });
  }
}
