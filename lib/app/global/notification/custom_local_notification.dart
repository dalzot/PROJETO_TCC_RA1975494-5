import 'dart:convert';

import 'package:delivery_servicos/core/util/print_exception.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/theme/app_color.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/provider/http_client.dart';
import '../../data/provider/http_client_get_connect.dart';

class CustomLocalNotification {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  CustomLocalNotification() {
    channel = const AndroidNotificationChannel(
      'hight-importance-channel',
      'Hight Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.orange,
      showBadge: true,
    );

    _settingsAndroid().then((value) {
      flutterLocalNotificationsPlugin = value;
      initializedNotification();
    });
  }

  Future<FlutterLocalNotificationsPlugin> _settingsAndroid() async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    return flutterLocalNotificationsPlugin;
  }

  initializedNotification() {
    const android =
        AndroidInitializationSettings('@drawable/ic_stat_notification');

    final iOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (_, __, ___, ____) {},
    );

    flutterLocalNotificationsPlugin.initialize(InitializationSettings(
      android: android,
      iOS: iOS,
    ));
  }

  androidNotification(
    RemoteNotification notification,
    AndroidNotification android,
  ) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: android.smallIcon,
          color: appNormalPrimaryColor,
          priority: Priority.max,
          enableLights: true,
          enableVibration: true,
          ledColor: appNormalPrimaryColor,
          ledOnMs: 500,
          ledOffMs: 500,
          playSound: true,
          visibility: NotificationVisibility.public,
        ),
      ),
    );
  }

  scheduleAndroidNotification(
      String title, String body, DateTime scheduledTime) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        99,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_stat_notification',
            color: appNormalPrimaryColor,
            priority: Priority.max,
            enableLights: true,
            enableVibration: true,
            ledColor: appNormalPrimaryColor,
            ledOnMs: 500,
            ledOffMs: 500,
            playSound: true,
            visibility: NotificationVisibility.public,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  appleNotification(
    RemoteNotification notification,
    AppleNotification apple,
  ) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
          subtitle: notification.title,
          threadIdentifier: "heyjobsPush",
        ),
      ),
    );
  }

  scheduleIOSNotification(
      String title, String body, DateTime scheduledTime) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        99,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            badgeNumber: 1,
            subtitle: title,
            threadIdentifier: "heyjobsPush",
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future sendPrivateMessaging(String titulo, String msg, String serviceId, String toCode) async {
    try {
      final HttpClient _httpClient = HttpClientGetConnect();
      const String serverToken = 'AAAA3sz6m2k:APA91bHLqPxIU78XrJmiZIW8I1O8Wth11bFrp1jy5omPBlpvwhsbWkK5clcANGFrB8M9YGGtUtSY7gH4nZmYiBvs3o85NPuRER9qLNemM7bpuvK2eb8tWPc3IIvFkTP6c2S4L0wzV0_K';

      final response = await _httpClient.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: <String, dynamic>{
          'notification': <String, dynamic>{
            'body': msg,
            'title': titulo
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'id': serviceId,
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'body': msg,
            'title': titulo,
            'status': 'done'
          },
          'to': toCode,
        },
      );
      print('response: ${response.data}');
    } catch(e, st) {
      printException("sendPrivateMessaging", e, st);
    }
  }
}
