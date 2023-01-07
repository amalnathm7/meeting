import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingFirebase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSeller(String id) async {
    await _firebaseFirestore.collection("sellers").doc(id).set({
      'isCalling': false,
      'isAccepted': false,
    }, SetOptions(merge: true));
  }

  Future<void> callSeller(String id) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isCalling': true,
    });
  }

  Future<void> acceptCall(String id) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isAccepted': true,
    });
  }

  Future<void> cutCall(String id) async {
    await _firebaseFirestore.collection("sellers").doc(id).update({
      'isCalling': false,
      'isAccepted': false,
    });
  }
}
