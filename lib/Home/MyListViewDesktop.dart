import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Home/Description.dart';
import 'package:mymenu/Models/FoodItem.dart';

class MyListViewDesktop extends StatefulWidget {
  List<FoodItem> foodAndConnect;

  MyListViewDesktop({this.foodAndConnect});
  @override
  _MyListViewDesktopState createState() => _MyListViewDesktopState();
}

class _MyListViewDesktopState extends State<MyListViewDesktop> {
  void _showSettingsPanel(FoodItem food){
    showModalBottomSheet(context: context, builder:(context){
      //builder shows widget tree to display in bottom sheet
      return Container(
        padding:EdgeInsets.symmetric(vertical: 20,horizontal: 60),
        child:Description(food:food),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return Container(
      height: screenSize.height * 0.5,


      child: GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.foodAndConnect.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal:60,vertical:80),

              //height: 220,
              height: screenSize.height * 0.1,

              //width:300,
              width: screenSize.width * 0.4,
              child: GestureDetector(
                onTap: () {
                  _showSettingsPanel(widget.foodAndConnect[index]);
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
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.4,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.4,
                            child: Image(
                                image: NetworkImage(
                                    widget.foodAndConnect[index].image),
                                fit: BoxFit.cover
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  widget.foodAndConnect[index].title,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white
                                  )
                              ),
                              Text(
                                  "R${widget.foodAndConnect[index].price
                                      .toStringAsFixed(2)}",
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
            );
          }
      ),
    );
  }
}
