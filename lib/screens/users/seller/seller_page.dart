import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:meeting/screens/call/call_page.dart';
import 'package:meeting/services/firebase.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  bool _isCalling = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.id)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        if (mounted) {
          setState(() {
            _isCalling = event.data()!['isCalling'];
          });

          if (_isCalling && !event.data()!['isAccepted']) {
            FlutterRingtonePlayer.playRingtone();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.1,
            right: size.width * 0.1,
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
                flex: 8,
                child: Center(
                  child: Text(
                    _isCalling ? "Call incoming" : "No active call",
                    style: TextStyle(fontSize: size.height * 0.02),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              if (_isCalling)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            MeetingFirebase().cutCall(widget.id);
                            FlutterRingtonePlayer.stop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                "Decline",
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FlutterRingtonePlayer.stop();
                            MeetingFirebase()
                                .acceptCall(widget.id)
                                .then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CallPage(channel: widget.id)));
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                "Accept",
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
