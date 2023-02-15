import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingFirebase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSeller(String id) async {
    await _firebaseFirestore.collection("sellers").doc(id).set({
      'isCalling': false,
      'isAccepted': false,
      'buyerId': '',
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
}
