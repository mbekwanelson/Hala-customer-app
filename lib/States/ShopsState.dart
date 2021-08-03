import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as l2;
import 'package:location/location.dart' as l;
import 'package:mymenu/Maps/Requests/GoogleMapsServices.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/Option.dart';
import 'package:mymenu/Models/Restuarant.dart';
import 'package:mymenu/Models/Shop.dart';




class ShopsState with ChangeNotifier{

  List<FoodItem> food =[];
  final double CUTOFFDISTANCE = 300000.00;

  //constructor
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

  Stream<List<Shop>> getShops({String category,Position currentUserPosition}) async* {
    List<Shop> shops = [];
      CollectionReference collectionReference =  Firestore.instance.collection("Options").document(category).collection(category); //.//snapshots();
       Future<QuerySnapshot> fquerySnapshot = collectionReference.getDocuments();

       QuerySnapshot snapshot = await fquerySnapshot; //.then((snapshot) async {
    try {
      for (int shop = 0; shop < snapshot.documents.length; shop++) {
        double lat = snapshot.documents[shop].data["latitude"];
        double long = snapshot.documents[shop].data["longitude"];
        print(snapshot.documents[shop].data["name"]);
        print(lat);
        print(long);
        print("VS");
        print(currentUserPosition.latitude);
        print(currentUserPosition.longitude);

        final l2.Distance distance = new l2.Distance();


        double km = 0.00;
        String carRouteDistance = await GoogleMapsServices()
            .getRouteCoordinates(
            LatLng(currentUserPosition.latitude, currentUserPosition.longitude),
            LatLng(lat, long));
        km = double.parse(carRouteDistance) / 1000;
        print("km:$km");
        // need to change km

        if (km <= 10.00) {
          print("km:$km");
          print("IN ${snapshot.documents[shop].data["name"]}");
          shops.add(Shop(
            shopName: snapshot.documents[shop].data["name"],
            shopBackground: snapshot.documents[shop].data["background"],
            categories: snapshot.documents[shop].data["categories"],
            category: snapshot.documents[shop].data["category"],
            longitude: long,
            latitude: lat,
          ));
          print(shop);
        }

      }
      print(shops);
    }
    catch(a,e){
      print(e);
      print(a);
    }

       yield shops;
    }
}