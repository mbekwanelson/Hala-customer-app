
import 'package:mymenu/Models/ConfirmCheckOut.dart';
import 'package:mymenu/Models/Order.dart';

class Price{

  double price;
  double promo;

  Price({this.price=0});

 double calculatePrice(List<ConfirmCheckOut> orders) {

   price = 0;
    for (ConfirmCheckOut order in orders) {

      price += order.quantity * order.price;
  }
    return price;

  }
}