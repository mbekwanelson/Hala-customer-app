
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Home/PeronalizeMeal.dart';
import 'package:mymenu/Models/Meal.dart';
import 'package:mymenu/Shared/Loading.dart';
class MealDescription extends StatefulWidget {

  List<Meal> meals;

  MealDescription({this.meals});
  @override
  _MealDescriptionState createState() => _MealDescriptionState();
}

class _MealDescriptionState extends State<MealDescription> {
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel(Meal meal) {


      showModalBottomSheet(isScrollControlled:true, context: context, builder: (context) {

        //builder shows widget tree to display in bottom sheet
        return Container(
          //height:MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: PersonalizeMeal(meal: meal),
        );
      });
    }

    return widget.meals.isEmpty ?
    Loading() : Container(
      child: Expanded(
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
          //shrinkWrap: true,
            itemCount: widget.meals.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Container(
                  height: 220,
                  width: 300,
                  child: GestureDetector(
                    onTap: () {
                      _showSettingsPanel(widget.meals[index]);

                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.black,
                        //color:Colors.grey[200],
                        child: Column(
                          children: [
                            Container(
                                height: 150,
                                width: 800,
                                child: Image(
                                    image: NetworkImage(
                                        widget.meals[index].image),
                                    fit: BoxFit.fitWidth
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                      widget.meals[index].title,
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white
                                      )
                                  ),
                                  Text(
                                      "R${widget.meals[index].initialPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,

                                      )
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),


                        elevation: 0),
                  ),
                ),

              );
            }
        ),
      ),
    );
  }
}