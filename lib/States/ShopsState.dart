import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as l2;
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
      print("categories______________________-${doc.data()["categories"]}");
      // returning a brew object for each document
      return Restaurant(
          restaurantName: doc.id,
          restaurantBackground: doc.data()["picture"],
          categories: doc.data()["categories"]);
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
        double lat = snapshot.docs[shop].data()["latitude"];
        double long = snapshot.docs[shop].data()["longitude"];

        DateTime currentTime = DateTime.now();
        int Year = currentTime.year;
        int Day = currentTime.day;
        int Month = currentTime.month;

        DateTime _CurrentTime = new DateTime(
            Year, Month, Day, currentTime.hour, currentTime.minute);
        DateTime openingTime =
            snapshot.docs[shop].data()["OpeningTime"].toDate();
        DateTime _OpeningTime = new DateTime(
            Year, Month, Day, openingTime.hour, openingTime.minute);
        DateTime closingTime =
            snapshot.docs[shop].data()["ClosingTime"].toDate();
        DateTime _ClosingTime = new DateTime(
            Year, Month, Day, closingTime.hour, closingTime.minute);
        bool isShopOperating = _CurrentTime.isAfter(_OpeningTime) &&
            _CurrentTime.isBefore(_ClosingTime);

        final l2.Distance distance = new l2.Distance();
        double km = 0.00;
        String carRouteDistance = await GoogleMapsServices()
            .getRouteCoordinates(
                LatLng(currentUserPosition.latitude,
                    currentUserPosition.longitude),
                LatLng(lat, long));

        km = double.parse(carRouteDistance) / 1000;
        if (km <= CUTOFFDISTANCE) {
          shops.add(Shop(
            shopName: snapshot.docs[shop].data()["name"],
            shopBackground: snapshot.docs[shop].data()["background"],
            categories: snapshot.docs[shop].data()["categories"],
            category: snapshot.docs[shop].data()["category"],
            longitude: long,
            latitude: lat,
            isShopOperating: isShopOperating,
            openingTime: _OpeningTime.toString(),
            closingTime: _ClosingTime.toString(),
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
