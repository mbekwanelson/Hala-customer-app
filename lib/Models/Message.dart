

import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String from;
  String message;
  Timestamp time;

  Message({this.message,this.from,this.time});


}