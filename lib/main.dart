import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:meeting/screens/users/buyer/buyer_page.dart';
import 'package:meeting/screens/users/seller/seller_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  _showNotification(
      message.data['title'], message.data['body'], message.data.toString());
}

Future<void> _showNotification(
    String title, String body, String payload) async {
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int appCategory = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meeting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: appCategory == 0
          ? const BuyerPage(
              id: "buyer1",
            )
          : appCategory == 1
              ? const BuyerPage(
                  id: "buyer2",
                )
              : appCategory == 2
                  ? const SellerPage(
                      id: "seller1",
                    )
                  : appCategory == 3
                      ? const SellerPage(
                          id: "seller2",
                        )
                      : const SellerPage(
                          id: "seller3",
                        ),
    );
  }
}
