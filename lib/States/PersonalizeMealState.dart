import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/Meal.dart';

class PersonalizeMealState {
  //saves user orders to database
  Future updateUserData(Meal meal) async {
    var uid = await Auth().inputData();
    List<String> selectedOptions = [];
    for (int option = 0; option < meal.selected.length; option++) {
      selectedOptions.add(meal.selected[option].title);
    }

    var docData = {
      "${meal.title}": {
        "title": meal.title,
        "price": meal.finalPrice,
        "category": "Meal",
        "selectedOptions": selectedOptions,
        "quantity": 1,
        "image": meal.image,
        "active": 1,
        "date": DateTime.now(),
        "shop": meal.shop,
        "checkOut": "No",
        "driverSeen": null,
        "shopSeen": null,
        "orderCollected": null
      }
    };

    return await FirebaseFirestore.instance
        .collection("OrdersRefined")
        .doc(uid)
        .set(docData, merge: true);
  }

  Future checkIfSameShop(String shop) async {
    String shopName;
    var uid = await Auth().inputData();
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
    }
    return true;
  }
}
