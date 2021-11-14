import 'package:flutter/material.dart';
import 'package:mymenu/Home/MyListViewDesktop.dart';
import 'package:mymenu/Home/MyListViewPhone.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Shared/Loading.dart';

class MyListView extends StatefulWidget {
  List<FoodItem> foodAndConnect;
  String category;

  MyListView({this.foodAndConnect, this.category});
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  @override
  Widget build(BuildContext context) {
    Orientation screenSize = MediaQuery.of(context).orientation;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? "Yes"
        : "No";

    if (widget.foodAndConnect.length == 0) {
      return Expanded(child: Loading());
    } else {
      return MyListViewPhone(
          foodAndConnect: widget.foodAndConnect, category: widget.category);
      return isPortrait == "Yes"
          ? MyListViewPhone(
              foodAndConnect: widget.foodAndConnect,
            )
          : MyListViewDesktop(foodAndConnect: widget.foodAndConnect);
    }
  }
}
