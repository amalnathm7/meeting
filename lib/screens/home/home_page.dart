import 'package:flutter/material.dart';
import 'package:meeting/screens/users/buyer/buyer_page.dart';
import 'package:meeting/screens/users/seller/seller_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.2,
            right: size.width * 0.2,
          ),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                "Meeting",
                style: TextStyle(fontSize: size.height * 0.05),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuyerPage(id: "buyer1",)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Buyer",
                        style: TextStyle(fontSize: size.height * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SellerPage(
                                  id: "seller1",
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Seller 1",
                        style: TextStyle(fontSize: size.height * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SellerPage(
                                  id: "seller2",
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Seller 2",
                        style: TextStyle(fontSize: size.height * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SellerPage(
                                  id: "seller3",
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Seller 3",
                        style: TextStyle(fontSize: size.height * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
