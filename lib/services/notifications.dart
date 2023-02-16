import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

Future<void> cancelNotification() async {
  FlutterRingtonePlayer.stop();
  final sendPort = IsolateNameServer.lookupPortByName('currentIsolate');
  sendPort?.send('stop');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> showNotification(String title, String body, String payload) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    onDidReceiveNotificationResponse: onSelectNotification,
  );
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title, // Notification title
    body, // Notification body
    platformChannelSpecifics, // Notification details
    payload: payload, // Payload
  );

  FlutterRingtonePlayer.playRingtone();

  final receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, 'currentIsolate');
  receivePort.listen((message) {
    FlutterRingtonePlayer.stop();
  });
}

Future onSelectNotification(NotificationResponse? response) async {}
