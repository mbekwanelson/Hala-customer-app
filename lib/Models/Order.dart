
import 'package:mymenu/Models/FoodItem.dart';

class Order{
 String title;
 double price;
 String food_id;
 String image;
 int quantity;
 int numOrders;



  Order({this.title,this.image,this.price,this.food_id,this.quantity=1,this.numOrders});

}