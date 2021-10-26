import 'package:cloud_firestore/cloud_firestore.dart';

class OzowPaymentState {
  bool pastPayment(String uid) {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("CardPayments").doc(uid);
    if (doc.get() == null) {
      return false;
    } else {
      return true;
    }
  }
}
