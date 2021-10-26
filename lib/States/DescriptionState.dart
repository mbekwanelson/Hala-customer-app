import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:mymenu/Models/User.dart';

class DescriptionState with ChangeNotifier {
  int count = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adds quantity of food
  int addQuantity() {
    count++;
    return count;
  }

// decreases quantity of food
  int decreaseQuantity() {
    count--;
    return count;
  }

  // Returns user object which contains firebaseID
  CustomUser _userFromFireBaseUser(User user) {
    return user != null ? CustomUser(userId: user.uid) : null;
  }

  Future userId() async {
    final User user = await _auth.currentUser;

    return user.uid;
    // here you write the codes to input the data into firestore
  }

  //saves user orders to database
  Future updateUserData(FoodItem food, String id) async {
    var uid = await userId();
    var docData = {
      "${food.title}": {
        "title": food.title,
        "price": food.price,
        "quantity": food.quantity,
        "image": food.image,
        "active": 1,
        "date": DateTime.now(),
        "shop": food.shop,
        "checkOut": "No",
        "driverSeen": null,
        "shopSeen": null,
        "orderCollected": null
      }
    };

    return await FirebaseFirestore.instance
        .collection("OrdersRefined")
        .doc(uid)
        .set(docData, SetOptions(merge: true));
  }

  logOrderToCart({String title, int quantity, String shop, double price}) {
    FirebaseAnalytics().logEvent(name: "AddedToCart", parameters: {
      "title": title,
      "quantity": quantity,
      "shop": shop,
      "price": price
    });
  }

  Future checkIfSameShop(String shop) async {
    String shopName;
    var uid = await userId();
    DocumentSnapshot snapshot;
    DocumentSnapshot currentOrders;
    int count = 0;
    int numberOptions = 0;

    snapshot = await FirebaseFirestore.instance
        .collection('OrdersRefined')
        .doc(uid)
        .get();
    // gets all order items in database
    // checks for items that were not checked out

    if (snapshot.data != null) {
      List<dynamic> keys = snapshot.data.keys.toList();
      try {
        for (int i = 0; i < snapshot.data.length; i++) {
          if (snapshot.data[keys[i]]['checkOut'] == "No") {
            numberOptions++;
          }
        }
      } on Exception catch (e) {
        // TODO
        print('index null');
      }

      try {
        for (int i = 0; i < snapshot.data.length; i++) {
          if (snapshot.data[keys[i]]['shop'] == shop &&
              snapshot.data[keys[i]]['checkOut'] == "No") {
            count++;
          }
        }
      } on Exception catch (e) {
        // TODO
        print("null index final");
      }

      if (count == numberOptions || snapshot.data.length == 0) {
        return true;
      } else {
        return false;
      }

      snapshot.data.keys.forEach((element) {
        if (snapshot.data[element]['shop'] == shop &&
            snapshot.data[element]['checkOut'] == "No") {
          print("Same Shop");
          shop = 'Same shop';
          return true;
        } else {
          print("different shop");
          shop = 'different shop';
          return false;
        }
      });
      print("Shop is $shop");
    }
    return true;
    //   await Future.delayed(const Duration(seconds: 1), () => "1");
    //   shop = 'same no orders yet';
    //   print("Same Shop: no orders yet");
    //
    //
    //  return true;
  }
}
