import 'package:mymenu/Models/ConfirmCheckOut.dart';

class Price {
  double price;
  double promo;

  Price({this.price = 0});

  double calculatePrice(List<ConfirmCheckOut> orders, String paymentMethod) {
    price = 0;
    for (ConfirmCheckOut order in orders) {
      price += order.quantity * order.price;
    }
    return paymentMethod == "Card" ? (price * 1.04) : (price);
  }
}
