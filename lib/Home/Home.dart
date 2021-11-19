import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mymenu/Home/CheckOut.dart';
import 'package:mymenu/Home/MealDescription.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/Meal.dart';
import 'package:mymenu/Models/Shop.dart';

import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/Home/MyListView.dart';
import 'package:mymenu/Shared/UserDrawer.dart';
import 'package:mymenu/States/HomeState.dart';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Shop shop;
  String category;

  Home({this.shop, this.category});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print("home build");
    print('${widget.category} Home State Category');

    List<String> words = [
      "one",
      "two",
      "three",
      "four",
      "five",
      "one",
      "two",
      "three",
      "four",
      "five",
      "one",
      "two",
      "three",
      "four",
      "five"
    ];

    final foodItems = Provider.of<List<FoodItem>>(context);
    final homeState = Provider.of<HomeState>(context);

    print("food Items: $foodItems");
    print("homestate: $homeState");

    return foodItems == null
        ? Loading()
        : Scaffold(
            //backgroundColor: Colors.grey[100],
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70), // makes app bar taller
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  child: AppBar(
                    //backgroundColor: Colors.red[500],
                    backgroundColor: Colors.black,

                    elevation: 20,
                    title: Text(
                      foodItems[0].shop,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        wordSpacing: 2,
                        letterSpacing: 2,
                      ),
                    ),
                    centerTitle: true,
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 5),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('Picture/HalaLogo.jpeg'),
                          radius: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            drawer: UserDrawer(),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //filters
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            child: OutlineButton(
                              borderSide: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () async {
                                print("tab 0 clicked");
                                setState(() {
                                  homeState.tab = 0;
                                });

                                return MyListView(
                                    foodAndConnect: foodItems,
                                    category: widget.category);
                              },
                              child: Text("All",
                                  style: TextStyle(
                                    letterSpacing: 2,
                                  )),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            //height: 50,

                            height: MediaQuery.of(context).size.height * 0.062,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.shop.categories.length,
                                itemBuilder: (context, index) {
                                  Map<String, IconData> map = {
                                    "Pizza": Icons.local_pizza_outlined,
                                    "drinks": Icons.wine_bar_sharp,
                                    "Meals": Icons.fastfood,
                                  };

                                  return Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: GestureDetector(
                                      child: OutlineButton.icon(
                                        textColor: Colors.black26,
                                        icon: Icon(
                                            map[widget.shop.categories[index]]),
                                        color: Colors.black,
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        onPressed: () async {
                                          if (widget.shop.categories[index] ==
                                              "Meals") {
                                            List<Meal> meals =
                                                await homeState.allMeals(
                                                    widget.shop,
                                                    widget.shop
                                                        .categories[index]);

                                            return Container(
                                              child: Text("hello"),
                                            );
                                            //return MealDescription(meals: meals,);
                                          } else {
                                            await homeState.category(
                                                widget.shop,
                                                widget.shop.categories[index]);

                                            print(homeState.selectedCategory);
                                            return Container(
                                              child: Text("hello"),
                                            );

                                            // return MyListView(foodAndConnect: homeState
                                            //     .selectedCategory);
                                          }
                                        },
                                        label:
                                            Text(widget.shop.categories[index],
                                                style: TextStyle(
                                                  letterSpacing: 2,
                                                )),
                                      ),
                                      onTap: () async {
                                        // await homeState.category(widget.shop.shopName, widget.shop.categories[index]);
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (homeState.tab == 0) MyListView(foodAndConnect: foodItems),
                  if (homeState.tab == 1)
                    MyListView(foodAndConnect: homeState.selectedCategory),
                  if (homeState.tab == 2)
                    MealDescription(meals: homeState.meals),
                  if (homeState.tab == 3)
                    MyListView(foodAndConnect: homeState.desserts),
                  //checkout btn
                  Container(
                    width: 165,
                    //color:Colors.grey[500],
                    color: Colors.black,
                    margin: EdgeInsets.only(bottom: 10),
                    //height:50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: FlatButton(
                            onPressed: () {
                              print("checkout btn pressed");
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckOut(
                                            shop: widget.shop,
                                            category: widget.category)));
                              });
                            },
                            child: Text(
                              "Check Out",
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  color: Colors.white),
                            ),
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
