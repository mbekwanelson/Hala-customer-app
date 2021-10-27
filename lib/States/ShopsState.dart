import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlong2/latlong.dart' as l2;
import 'package:mymenu/Maps/Requests/GoogleMapsServices.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/Restuarant.dart';
import 'package:mymenu/Models/Shop.dart';

class ShopsState with ChangeNotifier {
  List<FoodItem> food = [];
  final double CUTOFFDISTANCE = 400.00;

  //constructor
  ShopsState();

// GETS Shop MENU

  List<FoodItem> _shopChosenFromSnapshot(QuerySnapshot snapshot) {
    try {
      for (int data = 0; data < snapshot.docs.length; data++) {
        food.add(FoodItem(
          id: snapshot.docs[data]["id"],
          title: snapshot.docs[data]["title"],
          image: snapshot.docs[data]["image"],
          price: snapshot.docs[data]["price"],
          category: snapshot.docs[data]["category"],
          shop: snapshot.docs[data]["shop"] ?? "shop",
          inStock: snapshot.docs[data]["inStock"] ?? true,
          //inStock : snapshot.docs[data]["inStock"] ?? true
        ));
      }
    } catch (e) {}
    return food;
  }

  Stream<List<FoodItem>> shopChosen({String category, String shopChosen}) {
    //returns snapshot of database and tells us of any changes [provider]
    return FirebaseFirestore.instance
        .collection("Options")
        .doc(category)
        .collection(category)
        .doc(shopChosen)
        .collection("Items")
        .snapshots()
        .map(_shopChosenFromSnapshot);
  }

  // RETURNS ALL RESTAURANTS IN DATABASE

  List<Restaurant> _numRestaurants(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //! TODO sya : needs testing : removed .data
      // print("categories______________________-${doc.data["categories"]}");
      print("categories______________________-${doc["categories"]}");
      // returning a brew object for each document
      return Restaurant(
          restaurantName: doc.id,
          restaurantBackground: doc["picture"],
          categories: doc["categories"]);
    }).toList();
  }

  Stream<List<Restaurant>> numberRestaurants() {
    //returns snapshot of database and tells us of any changes [provider]
    return FirebaseFirestore.instance
        .collection("Restaurants")
        .snapshots()
        .map(_numRestaurants);
  }

  logShopSelected(String shop) {
    FirebaseAnalytics().logEvent(name: "Selected Shop", parameters: {
      "Shop": shop,
    });
  }

  Stream<List<Shop>> getShops(
      {String category, Position currentUserPosition}) async* {
    List<Shop> shops = [];
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("Options")
        .doc(category)
        .collection(category); //.//snapshots();
    Future<QuerySnapshot> fquerySnapshot = collectionReference.get();

    QuerySnapshot snapshot = await fquerySnapshot; //.then((snapshot) async {
    try {
      for (int shop = 0; shop < snapshot.docs.length; shop++) {
        // double lat = snapshot.docs[shop].data["latitude"];
        double lat = snapshot.docs[shop]["latitude"];
        double long = snapshot.docs[shop]["longitude"];

        DateTime currentTime = DateTime.now();
        int year = currentTime.year;
        int day = currentTime.day;
        int month = currentTime.month;

        DateTime _currentTime = new DateTime(
            year, month, day, currentTime.hour, currentTime.minute);
        DateTime openingTime = snapshot.docs[shop]["OpeningTime"].toDate();
        DateTime _openingTime = new DateTime(
            year, month, day, openingTime.hour, openingTime.minute);
        DateTime closingTime = snapshot.docs[shop]["ClosingTime"].toDate();
        DateTime _closingTime = new DateTime(
            year, month, day, closingTime.hour, closingTime.minute);
        bool isShopOperating = _currentTime.isAfter(_openingTime) &&
            _currentTime.isBefore(_closingTime);

        // final l2.Distance distance = new l2.Distance();
        double km = 0.00;
        String carRouteDistance = await GoogleMapsServices()
            .getRouteCoordinates(
                LatLng(currentUserPosition.latitude,
                    currentUserPosition.longitude),
                LatLng(lat, long));

        km = double.parse(carRouteDistance) / 1000;
        if (km <= CUTOFFDISTANCE) {
          shops.add(Shop(
            //! TODO sya : needs testing : removed .data
            // shopName: snapshot.docs[shop].data["name"],
            shopName: snapshot.docs[shop]["name"],
            shopBackground: snapshot.docs[shop]["background"],
            categories: snapshot.docs[shop]["categories"],
            category: snapshot.docs[shop]["category"],
            longitude: long,
            latitude: lat,
            isShopOperating: isShopOperating,
            openingTime: _openingTime.toString(),
            closingTime: _closingTime.toString(),
          ));
          print(shop);
        }
      }
      print(shops);
    } catch (a, e) {
      print(e);
      print(a);
    }

    yield shops;
  }
}
