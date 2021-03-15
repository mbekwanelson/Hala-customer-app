
import 'package:mymenu/Models/MealOption.dart';

class Meal{
  String title;
  String image;
  double initialPrice;
  int n;
  double finalPrice;
  List<MealOption> option1;
  List<MealOption> option2;
  List<MealOption> option3;
  List<MealOption> option4;
  List<MealOption> option5;
  List<MealOption> option6;
  List<MealOption> option7;
  List<MealOption> option8;
  List<MealOption> option9;
  List<MealOption> option10;
  List<List<MealOption>> differentOptions;
  List<MealOption> selected;
  String shop;

  Meal({this.title,this.image,this.initialPrice,this.shop}){
    n=0;
    differentOptions = [option1,option2,option3,option4,option5,option6,option7,option8,option9,option10];
  }

  addOption(List<MealOption> option){

    this.differentOptions[n] = [];
    for(int i =0;i<option.length;i++){
      this.differentOptions[n].add(MealOption(
          price:option[i].price,
          category: option[i].category,
          title: option[i].title
      ));
    }
    n++;



  }

 int availableOptions(){
    int available =0;
    for(int i = 0;i<this.differentOptions.length;i++) {
      try {
        if (this.differentOptions[i].isNotEmpty) {
          print(' avalable options: $i ${this.differentOptions[i]}');
          available++;
        }
      }
      catch(e){

      }
    }
    print(' available number: $available');
    return available;
    }






}