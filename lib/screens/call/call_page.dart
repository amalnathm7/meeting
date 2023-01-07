import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting/services/firebase.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key, required this.channel}) : super(key: key);
  final String channel;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool _isInitialised = false;
  late final AgoraClient client;

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.channel)
        .snapshots()
        .listen((event) {
      if (event.exists && event.data() != null) {
        if (mounted) {
          if (!event.data()!['isCalling']) {
            client.engine.leaveChannel();
            Navigator.pop(context);
          }
        }
      }
    });
    initAgora();
  }

  void initAgora() async {
    // Instantiate the client
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "89a27244bbe542c8b4a4a1ce41d54a41",
        channelName: widget.channel,
      ),
    );
    await client.initialize();
    if (mounted) {
      setState(() {
        _isInitialised = true;
      });
    }
  }

// Build layout
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: _isInitialised
              ? Stack(
                  children: [
                    AgoraVideoViewer(client: client),
                    AgoraVideoButtons(
                      client: client,
                      onDisconnect: () {
                        MeetingFirebase().cutCall(widget.channel).then((value) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
