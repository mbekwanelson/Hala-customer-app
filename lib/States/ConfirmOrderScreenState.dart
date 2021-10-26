import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/ConfirmOrder.dart';

class ConfirmOrderScreenState {
  List<ConfirmOrder> _ordersPlaced(DocumentSnapshot snapshot) {
    //! TODO sya : needs testing : deprecated data and keys loop
    // Getting a snapshots' data via the data getter is now done via the data() method.
    Map<String, dynamic> data = snapshot.data();
    print("There");
    // print("You have ordered ${snapshot.data.length} Items");
    print("You have ordered ${data.length} Items");
    return null;
  }

  Future confirmOrders() async {
    List<ConfirmOrder> confirmOrders = [];
    dynamic uid = await Auth().inputData();
    await FirebaseFirestore.instance
        .collection("OrdersShops")
        .doc("OrdersShops")
        .collection("Food and Connect")
        .doc(uid)
        .snapshots()
        .forEach((element) {
      //! TODO sya : needs testing : deprecated data and keys loop
      // Getting a snapshots' data via the data getter is now done via the data() method.
      Map<String, dynamic> data = element.data();
      // element.data.forEach((key, value) {
      data.forEach((key, value) {
        //print(" key = $key : value = ${value["title"]}");
        confirmOrders.add(ConfirmOrder(
            orderName: value['title'],
            price: value['price'].toDouble(),
            quantity: value['quantity'],
            date: value['date'].toDate(),
            shopName: "Food and Connect"));
      });

      print(data.length);
    });
    await Future.delayed(const Duration(seconds: 1), () => "1");
    return confirmOrders;
  }
}
