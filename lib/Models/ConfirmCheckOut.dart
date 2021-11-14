import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmCheckOut {
  String title;
  double price;
  Timestamp time;
  int quantity;
  String shop;
  List<dynamic> mealOptions;
  String category;

  ConfirmCheckOut(
      {this.title,
      this.price,
      this.quantity,
      this.time,
      this.shop,
      this.mealOptions,
      this.category});
}
