import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting/screens/call/call_page.dart';

class CallingPage extends StatefulWidget {
  const CallingPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  bool _isCalling = true;

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

          if (!_isCalling) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          } else if (event.data()!['isAccepted']) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CallPage(channel: widget.id)));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Text(
          _isCalling ? "Calling..." : "Call declined",
          style: TextStyle(
              fontSize: size.height * 0.02,
              color: _isCalling ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}
