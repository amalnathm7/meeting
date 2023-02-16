import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting/services/firebase.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key, required this.id, required this.buyerId})
      : super(key: key);
  final String id;
  final String buyerId;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool _isInitialised = false;
  late final AgoraClient client;
  late DateTime start;
  late DateTime end;

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.id)
        .snapshots()
        .listen((event) {
      if (event.exists && event.data() != null) {
        if (mounted) {
          if (!event.data()!['isCalling']) {
            endCall(
              sessionController: client.sessionController,
            );
            Navigator.pop(context);
          }
        }
      }
    });
    initAgora();
  }

  Future<void> endCall({required SessionController sessionController}) async {
    await sessionController.value.engine?.leaveChannel();
    if (sessionController.value.connectionData!.rtmEnabled) {
      await sessionController.value.agoraRtmChannel?.leave();
      await sessionController.value.agoraRtmClient?.logout();
    }
    await sessionController.value.engine?.stopPreview();
    await sessionController.value.engine?.release();
  }

  void initAgora() async {
    // Instantiate the client
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "89a27244bbe542c8b4a4a1ce41d54a41",
        channelName: widget.id,
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
                        end = DateTime.now();
                        MeetingFirebase()
                            .cutCall(widget.id, widget.buyerId, start,
                                end.difference(start))
                            .then((value) {
                          if (mounted) {
                            Navigator.pop(context);
                          }
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
