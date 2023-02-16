import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meeting/screens/users/buyer/buyer_page.dart';
import 'package:meeting/screens/users/seller/seller_page.dart';
import 'package:meeting/services/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((message) {
    _firebaseMessagingBackgroundHandler(message);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['title'] == 'cancel') {
    await cancelNotification();
  } else {
    await showNotification(
        message.data['title'], message.data['body'], message.data.toString());
  }
}

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
