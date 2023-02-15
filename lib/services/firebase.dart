import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingFirebase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSeller(String id, String token) async {
    await _firebaseFirestore.collection("sellers").doc(id).set({
      'isCalling': false,
      'isAccepted': false,
      'buyerId': '',
      'token': token,
    }, SetOptions(merge: true));
  }

  Future<void> updateToken(String id, String token) async {
    await _firebaseFirestore.collection("sellers").doc(id).set({
      'token': token,
    }, SetOptions(merge: true));
  }

  Future<void> callSeller(String id, String buyerId) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isCalling': true,
      'buyerId': buyerId,
    });
  }

  Future<void> acceptCall(String id) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isAccepted': true,
    });
  }

  Future<void> cancelCall(String id, String buyerId) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isCalling': false,
      'isAccepted': false,
      'buyerId': '',
    });

    await _firebaseFirestore
        .collection("sellers")
        .doc(id)
        .collection("missed_calls")
        .doc()
        .set({
      'id': buyerId,
      'time': DateTime.now(),
    });
  }

  Future<void> cutCall(
      String id, String buyerId, DateTime start, Duration duration) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isCalling': false,
      'isAccepted': false,
      'buyerId': '',
    });

    if (duration == Duration.zero) {
      await _firebaseFirestore
          .collection("sellers")
          .doc(id)
          .collection("rejected_calls")
          .doc()
          .set({
        'id': buyerId,
        'time': start,
      });
    } else {
      await _firebaseFirestore
          .collection("sellers")
          .doc(id)
          .collection("accepted_calls")
          .doc()
          .set({
        'id': buyerId,
        'time': start,
        'duration': duration.inSeconds,
      });
    }
  }

  Future<bool> callOnFcmApiSendPushNotifications(
      String token, String id, BuildContext context) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": token,
      "data": {
        "title": 'Incoming call from $id',
        "body": 'Click to open',
      },
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAthVSG4M:APA91bENvVmMoACGhQEjVRKOpdGNPJrQxxSJoCY20E0cRpiFrS8WYENlaxyvMkZSS67_4qD2375kYFXIQjZAltlEt3SJXri1ceS9Uoj09soLkD2PxEYpwCEl7oNXUt4S1xbyZZ5LQvdy' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sent!")));
      return true;
    } else {
      return false;
    }
  }
}
