
import 'package:mymenu/Models/FoodItem.dart';

class FoodChosen{

  List<FoodItem> foods;
  FoodItem food;

  FoodChosen({this.food});

  void add(FoodItem food){
    foods.add(food);
  }

  bool check (){
    for(int i=0;i<foods.length;i++){
      if(food.id == foods[i].id){
        return true;
      }

    }
    return false;
  }

}