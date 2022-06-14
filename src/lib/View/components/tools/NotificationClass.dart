import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import '../../../Controller/Controller.dart';
import 'dart:developer';
import '../../../Model/Language.dart' as globals;

class NotificationClass {
  BuildContext context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Controller controller = new Controller();

  Future showNotification(String name, String data) async {
    globals.notif = [
      globals.langue[38] + '$name',
      globals.langue[39] + '$data ' + globals.langue[40],
    ];
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      globals.langue[38] + '$name',
      globals.langue[39] + '$data ' + globals.langue[40],
      platformChannelSpecifics,
      payload: "$data : $name " + globals.langue[40],
    );
  }

  Future onSelectNotification(String payload) async {
    Navigator.of(context);
  }

  NotificationClass({Key key, this.context}) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    this.flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    this.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
}
