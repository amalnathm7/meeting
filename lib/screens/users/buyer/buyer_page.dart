import 'package:flutter/material.dart';
import 'package:meeting/screens/call/calling_page.dart';
import 'package:meeting/services/firebase.dart';

class BuyerPage extends StatefulWidget {
  const BuyerPage({Key? key}) : super(key: key);

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
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
                    MeetingFirebase().callSeller("seller1").then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CallingPage(id: "seller1")));
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Call Seller 1",
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
                    MeetingFirebase().callSeller("seller2").then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CallingPage(id: "seller2")));
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Call Seller 2",
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
                    MeetingFirebase().callSeller("seller3").then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CallingPage(id: "seller3")));
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Call Seller 3",
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
