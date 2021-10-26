import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/Message.dart';

class messageDriverState with ChangeNotifier {
  List<Message> messages = [];

  messageDriverState();

  sendDriverMessage(String msg) async {
    dynamic uid = await Auth().inputData();
    var data = {
      "${DateTime.now()}": {
        "message": msg,
        "from": "Customer",
        "time": DateTime.now()
      }
    };
    await FirebaseFirestore.instance
        .collection("Messages")
        .doc(uid)
        .set(data, merge: true);
  }

  List<Message> _messageFromSnapshot(DocumentSnapshot snapshot) {
    messages = [];
    snapshot.data.keys.forEach((element) {
      messages.add(Message(
          message: snapshot[element]["message"],
          time: snapshot[element]["time"],
          from: snapshot[element]["from"]));
    });

    // sorts time of messages
    messages.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    return messages;
  }

  Stream<List<Message>> Messages(dynamic uid) {
    return FirebaseFirestore.instance
        .collection("Messages")
        .doc(uid)
        .snapshots()
        .map(_messageFromSnapshot);
  }
}
