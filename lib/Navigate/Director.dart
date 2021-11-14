import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Home/Home.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/Shop.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/States/DescriptionState.dart';
import 'package:mymenu/States/HomeState.dart';
import 'package:mymenu/States/RegisterState.dart';
import 'package:mymenu/States/ShopsState.dart';
import 'package:mymenu/States/UserDrawerState.dart';
import 'package:provider/provider.dart';

class Director extends StatefulWidget {
  final Shop shop;
  final String category;

  Director({this.shop, this.category});
  @override
  _DirectorState createState() => _DirectorState();
}

class _DirectorState extends State<Director> {
  dynamic uid;
  @override
  void initState() {
    setState(() {
      uid = Auth().inputData();
    });
    // TODO: implement initState
    super.initState();
    // Auth().inputData().then((value) {
    //   setState(() {
    //     uid = value;
    //   });
    // });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return uid == null
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<List<FoodItem>>.value(
                  value: ShopsState().shopChosen(
                      shopChosen: widget.shop.shopName,
                      category: widget.category)),

              //ChangeNotifierProvider.value(value: AppState()),
              ChangeNotifierProvider.value(value: HomeState()),
              ChangeNotifierProvider.value(value: DescriptionState()),
              ChangeNotifierProvider.value(value: RegisterState()),
              ChangeNotifierProvider.value(value: UserDrawerState()),
              // StreamProvider<List<LocationN>>.value(value:Database().DriverLocation(uid)),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              // home: Home(
              //   restaurant:widget.restaurant
              // ),
              home: Home(shop: widget.shop, category: widget.category),
            ),
          );
  }
}
