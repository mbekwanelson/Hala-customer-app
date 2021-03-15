import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/Option.dart';
import 'package:mymenu/Models/Restuarant.dart';
import 'package:mymenu/Models/Shop.dart';



class ShopsState with ChangeNotifier{

  List<FoodItem> food =[];

  ShopsState();


// GETS Shop MENU

  List<FoodItem> _shopChosenFromSnapshot(QuerySnapshot snapshot){

    try {


      for (int data = 0; data < snapshot.documents.length; data++) {

        food.add(FoodItem(
          id:snapshot.documents[data]["id"],
          title: snapshot.documents[data]["title"],
          image: snapshot.documents[data]["image"],
          price: snapshot.documents[data]["price"],
          category: snapshot.documents[data]["category"],
          shop: snapshot.documents[data]["shop"] ?? "shop",
        ));
      }
    }







        // food.add(new FoodItem(
        //   title: element,
        //   price: snapshot[element]["price"],
        //   category: snapshot[element]["category"],
        //   restaurant: snapshot[element]["restaurant"] ??"not now",
        //   image: snapshot[element]["image"],
        //   id:snapshot[element]["id"] ??"not now",
        //


    catch(e){

    }

    return food;

  }

  Stream<List<FoodItem>> shopChosen({String category,String shopChosen}){
    print("  Directory      Options/$category/$category/$shopChosen");
    //returns snapshot of database and tells us of any changes [provider]
    return Firestore.instance.collection("Options").document(category).collection(category).document(shopChosen).collection("Items").snapshots().map(_shopChosenFromSnapshot);
  }


  // RETURNS ALL RESTAURANTS IN DATABASE

  List<Restaurant> _numRestaurants(QuerySnapshot snapshot){


    return snapshot.documents.map((doc){

      print("categories______________________-${doc.data["categories"]}");
      // returning a brew object for each document
      return Restaurant(
          restaurantName: doc.documentID,
          restaurantBackground: doc.data["picture"],
          categories: doc.data["categories"]
      );
    }).toList();
  }


  Stream<List<Restaurant>> numberRestaurants(){

    //returns snapshot of database and tells us of any changes [provider]
    return Firestore.instance.collection("Restaurants").snapshots().map( _numRestaurants);
  }

  logShopSelected(String shop) {
    FirebaseAnalytics().logEvent(name: "Selected Shop", parameters: {
      "Shop": shop,
    });
  }

  List<Shop> _shopsFromDb(QuerySnapshot snapshot){

    List<Shop> shops = [];

    for(int shop = 0;shop<snapshot.documents.length;shop++){

      shops.add(Shop(
          shopName: snapshot.documents[shop].data["name"],
          shopBackground: snapshot.documents[shop].data["background"],
          categories: snapshot.documents[shop].data["categories"],
          category:snapshot.documents[shop].data["category"]
      ));
    }
    return shops;

  }

  Stream<List<Shop>> getShops({String category}){

    return Firestore.instance.collection("Options").document(category).collection(category).snapshots().map(_shopsFromDb);
  }




}