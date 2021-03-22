import 'package:mymenu/Models/ConfirmCheckOut.dart';

class cardPaymentDetail{

  List<ConfirmCheckOut> orders;
  String promoIndex; // helps with knowing which promo user used
  String promoApplied;
  double promoValue;

  cardPaymentDetail({this.orders,this.promoApplied,this.promoIndex,this.promoValue});

}