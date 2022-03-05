import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mymenu/Models/ConfirmCheckOut.dart';

class Auth {
  //allows us to use firebase authentication -- line below

  final fbauth.FirebaseAuth _auth =
      fbauth.FirebaseAuth.instance; //_ means private in variable auth

  String uid;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //List<Order> orders = [Order(image: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg",price: 0,food_id: "placeholder")];
  //create user object based on Firebase user
  List<ConfirmCheckOut> orders = [];
  // User _userFromFireBaseUser(FirebaseUser user){
  //   return user!=null ? User(userId: user.uid) : null;
  // }
  // auth change user stream

  bool showSignIn = true;

  Stream<fbauth.User> get user {
    //tells us each time user signs in / out
    return _auth.authStateChanges();
  }

  //sign in with email and password

  //sign out
  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  //users connecting to database
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection("Orders");

  //CB and edit
  Future checkOutApprovedCash(
      ConfirmCheckOut food,
      double promo,
      String indexPromo,
      String promoApplied,
      double deliveryFee,
      String foodCategory) async {
    print("In here!");
    print(food.title);

    String uid = await inputData();
    DateTime date = DateTime.now();
    String time = date.toString();
    int index = time.indexOf('.');
    String timeUsed = time.substring(0, index);
    String mealOption = "";

    for (String option in food.mealOptions) {
      mealOption += option + ",";
    }

    await FirebaseFirestore.instance
        .collection("OrdersShops")
        .doc("OrdersShops")
        .collection(food.shop)
        .doc(uid)
        .set({
      "$timeUsed": {
        'title': food.title,
        'mealOptions': mealOption,
        'price': food.price,
        'quantity': food.quantity,
        'active': 1,
        'user': uid,
        'date': DateTime.now(),
        'shopSeen': "No",
        'promo': promoApplied == "Yes" ? promo : 0,
        'Payment Method': "Cash",
        "deliveryFee": deliveryFee
      }
    }, SetOptions(merge: true));
    await Future.delayed(const Duration(seconds: 1), () => "1");
    if (promoApplied == "Yes") {
      indexPromo.isEmpty
          ? print(indexPromo)
          : await FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .update({
              "promotions.$indexPromo.used": "Yes",
            });
    }

    return await FirebaseFirestore.instance
        .collection("OrdersRefined")
        .doc(uid)
        .update({
      "${food.title}.checkOut": "Yes",
      "${food.title}.promo": promoApplied == "Yes" ? promo : 0,
      "${food.title}.Payment Method": "Cash",
      "${food.title}.date": DateTime.now(),
      "${food.title}.deliveryFee": deliveryFee
    });
  }

  Future checkOutApprovedCard(
      ConfirmCheckOut food,
      double promo,
      String indexPromo,
      String promoApplied,
      double deliveryFee,
      String category) async {
    String uid = await inputData();
    DateTime date = DateTime.now();
    String time = date.toString();
    int index = time.indexOf('.');
    String timeUsed = time.substring(0, index);
    String mealOption = "";

    for (String option in food.mealOptions) {
      mealOption += option + ",";
    }

    await FirebaseFirestore.instance
        .collection("OrdersShops")
        .doc("OrdersShops")
        .collection(food.shop)
        .doc(uid)
        .set({
      "$timeUsed": {
        'title': food.title,
        'mealOptions': mealOption,
        'price': food.price,
        'quantity': food.quantity,
        'active': 1,
        'user': uid,
        'date': DateTime.now(),
        'shopSeen': "No",
        'checkOut': "Yes", //dec
        'promo': promoApplied == "Yes" ? promo : 0,
        "Payment Method": "Card",
        "deliveryFee": deliveryFee
      }
    }, SetOptions(merge: true));

    await Future.delayed(const Duration(seconds: 1), () => "1");
    if (promoApplied == "Yes") {
      indexPromo.isEmpty
          ? print(indexPromo)
          : await FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .update({
              "promotions.$indexPromo.used": "Yes",
            });
    }

    return await FirebaseFirestore.instance
        .collection("OrdersRefined")
        .doc(uid)
        .update({
      "${food.title}.checkOut": "Yes",
      "${food.title}.promo": promoApplied == "Yes" ? promo : 0,
      "${food.title}.Payment Method": "Card",
      "${food.title}.date": DateTime.now(),
      "${food.title}.deliveryFee": deliveryFee
    });
  }

  List<ConfirmCheckOut> _ordersFromSnapshot(DocumentSnapshot snapshot) {
    orders = [];
    snapshot.data().keys.forEach((element) {
      try {
        if (snapshot[element]["active"] == 1 &&
            snapshot[element]["checkOut"] != "Yes") {
          orders.add(ConfirmCheckOut(
              title: snapshot[element]["title"],
              price: snapshot[element]["price"],
              quantity: snapshot[element]["quantity"],
              time: snapshot[element]["date"],
              shop: snapshot[element]["shop"],
              mealOptions: snapshot[element]["selectedOptions"] ?? [],
              category: snapshot[element]["category"]));
        }
      } catch (e) {
        print(e);
      }
    });
    return orders;
  }

  Stream<List<ConfirmCheckOut>> myOrders(String user) {
    //returns snapshot of database and tells us of any changes [provider]

    return FirebaseFirestore.instance
        .collection("OrdersRefined")
        .doc(user)
        .snapshots()
        .map(_ordersFromSnapshot);
  }

  Future deleteFromDb(String id) async {
    String uid = await inputData();
    try {
      DocumentReference doc =
          FirebaseFirestore.instance.collection("OrdersRefined").doc(uid);
      doc.update({id: FieldValue.delete()});
    } catch (e) {
      print(e);
      return null;
    }
  }

  String inputData() {
    final fbauth.User user = _auth.currentUser;
    return user.uid;
    // here you write the codes to input the data into firestore
  }

  Future<String> isShopOperational(String shopName, String category) async {
    DocumentReference shopObject = await FirebaseFirestore.instance
        .collection("Options")
        .doc(category)
        .collection(category)
        .doc(shopName);
    DocumentSnapshot doc = await shopObject.get();

    DateTime currentTime = DateTime.now();
    int Year = currentTime.year;
    int Day = currentTime.day;
    int Month = currentTime.month;

    DateTime _CurrentTime =
        new DateTime(Year, Month, Day, currentTime.hour, currentTime.minute);

    DateTime openingTime =
        doc.data()["OpeningTime"].toDate(); //["OpeningTime"];
    DateTime _OpeningTime =
        new DateTime(Year, Month, Day, openingTime.hour, openingTime.minute);

    DateTime closingTime = doc.data()["ClosingTime"].toDate();
    DateTime _ClosingTime =
        new DateTime(Year, Month, Day, closingTime.hour, closingTime.minute);
    bool isShopOperating = _CurrentTime.isAfter(_OpeningTime) &&
        _CurrentTime.isBefore(_ClosingTime);

    return (!isShopOperating) ? "Closed" : "Opened";
  }
}
