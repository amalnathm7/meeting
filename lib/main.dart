import 'package:flutter/material.dart';
import 'package:meeting/screens/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meeting/screens/users/buyer/buyer_page.dart';
import 'package:meeting/screens/users/seller/seller_page.dart';
import 'package:meeting/services/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final int appCategory = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
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
