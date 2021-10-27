import 'package:mymenu/Models/ConfirmCheckOut.dart';

class CardPaymentDetail {
  List<ConfirmCheckOut> orders;
  String promoIndex; // helps with knowing which promo user used
  String promoApplied;
  double promoValue;

  CardPaymentDetail(
      {this.orders, this.promoApplied, this.promoIndex, this.promoValue});
}
