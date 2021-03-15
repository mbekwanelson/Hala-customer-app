

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmCheckOut{

  String title;
  double price;
  Timestamp time;
  int quantity;
  String shop;
  List<dynamic> mealOptions;

  ConfirmCheckOut({this.title,this.price,this.quantity,this.time,this.shop,this.mealOptions});







}