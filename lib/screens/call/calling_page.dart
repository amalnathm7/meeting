import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting/screens/call/call_page.dart';
import 'package:meeting/services/firebase.dart';

class CallingPage extends StatefulWidget {
  const CallingPage({Key? key, required this.id, required this.buyerId})
      : super(key: key);
  final String id;
  final String buyerId;

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  bool _isCalling = true;
  bool _isCancelled = false;
  bool _isMissed = false;

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
            MeetingFirebase().callOnFcmApiSendPushNotifications(event.data()!['token'], widget.buyerId);
          });

          if (!_isCalling) {
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.pop(context);
              }
            });
          } else if (event.data()!['isAccepted']) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CallPage(
                          id: widget.id,
                          buyerId: widget.buyerId,
                        )));
          }
        }
      }
    });

    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _isMissed = true;
        });

        MeetingFirebase().cancelCall(widget.id, widget.buyerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        MeetingFirebase().cancelCall(widget.id, widget.buyerId);
        return true;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                _isCalling
                    ? "Calling ${widget.id}..."
                    : _isCancelled
                        ? "Call cancelled"
                        : _isMissed
                            ? "Call missed"
                            : "Call declined",
                style: TextStyle(
                    fontSize: size.height * 0.03,
                    color: _isCalling ? Colors.green : Colors.red),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            TextButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _isCancelled = true;
                  });
                }

                MeetingFirebase().cancelCall(widget.id, widget.buyerId);
              },
              child: Text(
                "Cancel call",
                style:
                    TextStyle(fontSize: size.height * 0.02, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
