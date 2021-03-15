
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Models/Restuarant.dart';
import 'package:mymenu/Models/Shop.dart';
import 'package:mymenu/Navigate/Director.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/Shared/UserDrawer.dart';
import 'package:mymenu/States/ShopsState.dart';
import 'package:mymenu/States/UserDrawerState.dart';
import 'package:provider/provider.dart';

class Shops extends StatefulWidget {
  String category;

  Shops({this.category});
  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  @override
  Widget build(BuildContext context) {

    final shops = Provider.of<List<Shop>>(context);
    final shopsState = Provider.of<ShopsState>(context);
    return shops==null ? Loading(): ChangeNotifierProvider.value(
      value: UserDrawerState(),
      child: Scaffold(
        drawer:UserDrawer(),
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            title: Text(
                "Home",
              style:TextStyle(
                fontSize: 23,
              )
            ),
            backgroundColor: Colors.grey[900],
            centerTitle: true,
          ),
        ),

        body: SafeArea(

          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(10, 50, 0, 30),
              //     child: Text(
              //         "Specials",
              //       style: TextStyle(
              //         color: Colors.amber,
              //         fontSize: 30,
              //         letterSpacing: 2,
              //         //fontWeight: FontWeight.bold
              //         //fontStyle:FontStyle.italic,
              //
              //
              //       ),
              //     ),
              //   ),
              // ),
              //
              // CarouselSlider.builder(
              //   options: CarouselOptions(
              //     height: 150,
              //     aspectRatio: 16/9,
              //     viewportFraction: 0.8,
              //     initialPage: 0,
              //     enableInfiniteScroll: true,
              //     reverse: false,
              //     autoPlay: true,
              //     autoPlayInterval: Duration(seconds: 8),
              //     autoPlayAnimationDuration: Duration(milliseconds: 800),
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     enlargeCenterPage: true,
              //     //onPageChanged: callbackFunction,
              //     scrollDirection: Axis.horizontal,
              //   ),
              //   itemCount: shops.length,
              //   itemBuilder: (BuildContext context, int index) =>
              //       Container(
              //         child: GestureDetector(
              //           onTap: (){
              //             shopsState.logShopSelected(shops[index].shopName);
              //
              //
              //
              //                 setState(() {
              //                   Navigator.push(
              //                       context,
              //                       MaterialPageRoute(builder: (context) => Director(shop: shops[index],category: widget.category,))
              //                   );
              //                 });
              //               },
              //           child: Card(
              //             shape:RoundedRectangleBorder(
              //
              //               borderRadius: BorderRadius.circular(60),
              //             ),
              //             child: Image(
              //               image:NetworkImage(shops[index].shopBackground ?? "https://www.bengi.nl/wp-content/uploads/2014/10/no-image-available1.png"),
              //               fit:BoxFit.cover,
              //             ),
              //           ),
              //         ),
              //       ),
              // ),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal:30),
//              child: Container(
//                color: Colors.black,
//                height:150,
//                width:MediaQuery.of(context).size.width,
//                child: ListView.builder(
//                    //shrinkWrap: true,
//                    scrollDirection: Axis.horizontal,
//                    itemCount:restaurants.length,
//                    itemBuilder: (context,index){
//                      return Padding(
//                        padding: const EdgeInsets.all(12),
//                        child: GestureDetector(
//                          child: Container(
//                            //width:300,
//                           // height:600,
//                            child: Card(
//                             // color:Colors.black,
//                              shape:RoundedRectangleBorder(
//
//                                borderRadius: BorderRadius.circular(60),
//                          ),
//                              child: Image(
//                                image:NetworkImage(restaurants[index].restaurantBackground ?? "https://www.bengi.nl/wp-content/uploads/2014/10/no-image-available1.png"),
//                                fit:BoxFit.cover,
//                              ),
//                            ),
//                          ),
//                          onTap: (){
//                            setState(() {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => Director(restaurant: restaurants[index],))
//                              );
//                            });
//                          },
//                        ),
//                      );
//                    }),
//              ),
//            ),
////            SizedBox(
////              height:50
////            ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,20,20,20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Shops",
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2,
                      //fontStyle:FontStyle.italic,
                      color: Colors.amber[300]


                    ),
                  ),
                ),
              ),
              SizedBox(
                height:30
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  itemCount: shops.length,
                    itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,20,20),
                      child: GestureDetector(
                        onTap:(){

                          shopsState.logShopSelected(shops[index].shopName);



                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Director(shop: shops[index],category: widget.category,))
                        );
                      });
                      },
                        child: Column(

                          children:[
                     Text(
                       shops[index].shopName,
                       style: TextStyle(
                         fontSize:18,
                         color:Colors.white,
                         letterSpacing: 3,
                       ),
                     ),
                            Expanded(
                              child: Container(
                                //width:300,
                                //height:600,
                                margin:EdgeInsets.all(20),



                                child:CircleAvatar(
                                  backgroundImage:NetworkImage(shops[index].shopBackground ?? "https://www.bengi.nl/wp-content/uploads/2014/10/no-image-available1.png"),
                                  radius:100,

                                ),
//                            Card(
//                              //color:Colors.black,
//                              child: Image(
//                                image:NetworkImage(restaurants[index].restaurantBackground ?? "https://www.bengi.nl/wp-content/uploads/2014/10/no-image-available1.png"),
//                                fit:BoxFit.cover,
//                              ),
//                            ),
                              ),
                            ),

                          ]
                        ),
                      ),
                    );
                    }
                ),
              ),
//            Container(
//                width: MediaQuery.of(context).size.width,
//                //height: 500,
//                color:Colors.red[900],
//              child: Row(
//                children: [
//                  FlatButton.icon(
//                      onPressed: (){},
//                      icon: Icon(Icons.home),
//                      label: Text("Home")
//                  )
//                ],
//              ),
//            ),
            ],
          ),
        )
      ),
    );
  }
}
