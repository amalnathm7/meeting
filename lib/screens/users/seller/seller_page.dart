import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:meeting/screens/call/call_page.dart';
import 'package:meeting/services/firebase.dart';
import 'package:intl/intl.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> with WidgetsBindingObserver {
  bool _isCalling = false;
  bool _isMinimised = false;
  String buyerId = "";

  final List<Map<String, dynamic>> _missedCalls = [];
  final List<Map<String, dynamic>> _acceptedCalls = [];
  final List<Map<String, dynamic>> _rejectedCalls = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _isMinimised = true;
    } else if (state == AppLifecycleState.resumed) {
      _isMinimised = false;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    FirebaseMessaging.instance.getToken().then((token) {
      MeetingFirebase().updateToken(widget.id, token!);
    });

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.id)
        .snapshots()
        .listen((event) async {
      if (event.exists) {
        if (mounted) {
          setState(() {
            _isCalling = event.data()!['isCalling'];
            buyerId = event.data()!['buyerId'];
          });

          final FlutterLocalNotificationsPlugin
              flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          final notificationAppLaunchDetails =
              await flutterLocalNotificationsPlugin
                  .getNotificationAppLaunchDetails();

          if (_isCalling &&
              (notificationAppLaunchDetails == null ||
                  !notificationAppLaunchDetails.didNotificationLaunchApp)) {
            if (!event.data()!['isAccepted'] && !_isMinimised) {
              FlutterRingtonePlayer.playRingtone();
            }
          } else {
            FlutterRingtonePlayer.stop();
          }
        }
      }
    });

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.id)
        .collection("missed_calls")
        .orderBy('time', descending: true)
        .snapshots()
        .listen((element) {
      if (mounted) {
        setState(() {
          _missedCalls.clear();
          for (var element in element.docs) {
            _missedCalls.add(element.data());
          }
        });
      }
    });

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.id)
        .collection("accepted_calls")
        .orderBy('time', descending: true)
        .snapshots()
        .listen((element) {
      if (mounted) {
        setState(() {
          _acceptedCalls.clear();
          for (var element in element.docs) {
            _acceptedCalls.add(element.data());
          }
        });
      }
    });

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.id)
        .collection("rejected_calls")
        .orderBy('time', descending: true)
        .snapshots()
        .listen((element) {
      if (mounted) {
        setState(() {
          _rejectedCalls.clear();
          for (var element in element.docs) {
            _rejectedCalls.add(element.data());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
                widget.id,
                style: TextStyle(fontSize: size.height * 0.05),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _isCalling
                        ? "Call incoming from $buyerId"
                        : "No active call",
                    style: TextStyle(fontSize: size.height * 0.02),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              if (!_isCalling)
                Expanded(
                  flex: 1,
                  child: PageView(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              "Missed Calls",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: Colors.red),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_missedCalls[index]['id']),
                                  subtitle: Text(DateFormat('d MMM, hh:mm a')
                                      .format(_missedCalls[index]['time']
                                          .toDate())),
                                );
                              },
                              itemCount: _missedCalls.length,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              "Accepted Calls",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: Colors.green),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_acceptedCalls[index]['id']),
                                  subtitle: Text(DateFormat('d MMM, hh:mm a')
                                      .format(_acceptedCalls[index]['time']
                                          .toDate())),
                                  trailing: Text(Duration(
                                          seconds: _acceptedCalls[index]
                                              ['duration'])
                                      .toString()
                                      .split('.')
                                      .first),
                                );
                              },
                              itemCount: _acceptedCalls.length,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              "Rejected Calls",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: Colors.orange),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_rejectedCalls[index]['id']),
                                  subtitle: Text(DateFormat('d MMM, hh:mm a')
                                      .format(_rejectedCalls[index]['time']
                                          .toDate())),
                                );
                              },
                              itemCount: _rejectedCalls.length,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (_isCalling)
                SizedBox(
                  height: size.height * 0.05,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            MeetingFirebase().cutCall(widget.id, buyerId,
                                DateTime.now(), Duration.zero);
                            FlutterRingtonePlayer.stop();
                            final sendPort = IsolateNameServer.lookupPortByName(
                                'currentIsolate');
                            sendPort?.send('stop');
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
                            final sendPort = IsolateNameServer.lookupPortByName(
                                'currentIsolate');
                            sendPort?.send('stop');
                            MeetingFirebase()
                                .acceptCall(widget.id)
                                .then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CallPage(
                                            id: widget.id,
                                            buyerId: buyerId,
                                          )));
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
