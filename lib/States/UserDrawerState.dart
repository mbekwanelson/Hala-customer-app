import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/Customer.dart';
import 'package:mymenu/Models/Promotion.dart';

class UserDrawerState with ChangeNotifier {
  TextEditingController promoCode = TextEditingController();

  String validPromo = "";
  String name;
  String email;

  List<String> promos = ["promo1", "promo2", "promo3"];
  UserDrawerState() {
    customerInfo();
    //validPromo = "";
  }
  Future _findPromos() async {
    // ignore: missing_return
    Promotion promotion = await FirebaseFirestore.instance
        .collection("Promotions")
        .get()
        .then((document) {
      for (int elementIndex = 0;
          elementIndex < document.docs.length;
          elementIndex++) {
        // print("${document.docs[elementIndex].data["promoCode"]} VS ${promoCode.text}");
        // if (promoCode.text == document.docs[elementIndex].data["promoCode"]) {
        if (promoCode.text == document.docs[elementIndex]["promoCode"]) {
          Promotion promo = Promotion(
            promoCode: document.docs[elementIndex]["promoCode"],
            promoValue: document.docs[elementIndex]["promoValue"],
            shop: document.docs[elementIndex].id,
          );

          return promo;
        }
      }
    });
    return promotion;
  }

  Future checkIfPromoUsed() async {
    DocumentSnapshot user;
    String uid = await Auth().inputData();
    user = await FirebaseFirestore.instance.collection("Users").doc(uid).get();
    await Future.delayed(const Duration(seconds: 1), () => "1");
    Map<String, dynamic> promos = user["promotions"];

    if (promos == null) {
      return false;
    }
    List<String> promotions = promos.keys.toList();

    for (int i = 0; i < promotions.length; i++) {
      if (promoCode.text == promos[promotions[i]]["promoCode"]) {
        return true;
        //promo used
      }
    }
    return false;
  }

  void verifyPromo() async {
    dynamic uid = await Auth().inputData();
    Promotion validPromoCheck = await _findPromos();
    bool promoUsed = await checkIfPromoUsed();
    await Future.delayed(const Duration(seconds: 1), () => "1");

    if (validPromoCheck != null && promoUsed == false) {
      DocumentSnapshot user =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      dynamic promos = user['promotions'];

      if (promos == null) {
        Map<String, dynamic> data = {
          'promotions': {
            "${DateTime.now()}".split('.').join(','): {
              "promoCode": promoCode.text,
              "used": "No"
            }
          }
        };
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(uid)
            .set(data, SetOptions(merge: true));
      } else {
        Map<String, dynamic> data = {
          "promotions": {
            "${DateTime.now()}".split('.').join(','): {
              "promoCode": promoCode.text,
              "used": "No"
            }
          }
        };
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(uid)
            .set(data, SetOptions(merge: true));
      }
      validPromo = "Successfully added Promo!";
      promoCode.clear();
      notifyListeners();
    } else if (promoUsed == true) {
      validPromo = "Promo already used!";
      promoCode.clear();
      notifyListeners();
    } else {
      validPromo = "Incorrect promo!";
      promoCode.clear();
      notifyListeners();
    }
  }

  bool _isPromoValid() {
    for (int p = 0; p < promos.length; p++) {
      if (promoCode.text == promos[p]) {
        return true;
      }
    }
    return false;
  }

  Future<Customer> customerInfo() async {
    String uid = await Auth().inputData();
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .snapshots()
        .forEach((element) {
      //print(element.data["email"]);
      Customer customer =
          //! TODO sya : needs testing : removed .data
          // Customer(name: element.data["name"], email: element.data["email"]);
          Customer(name: element["name"], email: element["email"]);
      name = element["name"];
      email = element["email"];
      return customer;
    });
  }

  bool _hasOrdered(DocumentSnapshot snapshot) {
    List<String> all = [];
    bool placedOrder = false;
    //! TODO sya : needs testing : deprecated data and keys loop
    // Getting a snapshots' data via the data getter is now done via the data() method.
    Map<String, dynamic> data = snapshot.data();
    // snapshot.data.keys.forEach((element) {
    data.keys.forEach((element) {
      try {
        if (snapshot[element]["active"] == 1) {
          placedOrder = true;
        }
      } catch (e) {
        print(e);
      }
    });
    return placedOrder;
  }

  Stream<bool> hasCustomerOrdered() {
    dynamic uid = Auth().inputData();
    return FirebaseFirestore.instance
        .collection('OrdersRefined')
        .doc(uid)
        .snapshots()
        .map(_hasOrdered);
  }

  logUser() {
    FirebaseAnalytics().setCurrentScreen(screenName: "UserDrawerScreen");
    // FirebaseAnalytics().logEvent(name: "userDrawerOpened",parameters: {
    //   "name": name,
    //   "email": email
    // });
  }

  setOccupation(String occupation) {
    FirebaseAnalytics().setUserProperty(name: "Ocupation", value: occupation);
  }
}
