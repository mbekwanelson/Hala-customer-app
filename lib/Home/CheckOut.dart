import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mymenu/Home/AfterCheckOut.dart';
import 'package:mymenu/Home/OrderPlaced.dart';
import 'package:mymenu/Home/messageDriver.dart';
import 'package:mymenu/Maps/MyMap.dart';
import 'package:mymenu/Models/ConfirmCheckOut.dart';
import 'package:mymenu/Models/Order.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/PromoCheckOut.dart';
import 'package:mymenu/Models/Promotion.dart';
import 'package:mymenu/Models/cardPaymentDetail.dart';
import 'package:mymenu/OzowPayment/OzowPayment.dart';
import 'package:mymenu/Shared/Database.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/Shared/Price.dart';
import 'package:mymenu/States/AfterCheckOutState.dart';
import 'package:mymenu/States/CheckOutState.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  Auth _auth = Auth();
  var _user;
  String shop;
  PromoCheckOut promo = PromoCheckOut();
  int promoStop =0;
  String promoApplied;
  String dropdownValue = "Cash";
  int extraCardFee = 2;


  @override
  // ignore: must_call_super
  void initState() {

    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    _auth.inputData().then((user) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _user = user;
        promo.index='';
        promo.promoValue = 0.0;
        promo.price = 0.0;
        promoApplied = "No";
      });
    });
  }

  // void _showSettingsPanel(){
  //   showModalBottomSheet(context: context, builder:(context){
  //     //builder shows widget tree to display in bottom sheet
  //     return Container(
  //       padding:EdgeInsets.symmetric(vertical: 20,horizontal: 60),
  //       child:Description(food:food),
  //     );
  //   });
  // }

  Widget build(BuildContext context) {

    Price price = Price();
    Auth _auth = Auth();

    double calculateTotal(List<ConfirmCheckOut> confirmCheckOut){
      if(price.calculatePrice(confirmCheckOut) > promo.price){
         if(promoStop==0){
           promoApplied= "Yes";
         }



        return price.calculatePrice(confirmCheckOut)*(1-promo.promoValue);

      }
      else{
        if(promoStop==0){
          promoApplied= "Yes";
        }

        return price.calculatePrice(confirmCheckOut);
      }

    }





   //List<Order> orders = Provider.of<List<Order>>(context);



    return StreamBuilder(
      stream:Auth().myOrders(_user),
      builder:(context,snapshot) {


        if (!snapshot.hasData) {
          return Loading();
        }
        price.promo=0;
            if(promoStop==0){
              List<ConfirmCheckOut> checkout = snapshot.data;

              if(checkout.isNotEmpty) {
                print("Tried to print shop: ${checkout[0].shop}");
                CheckOutState().shopPromo(checkout[0].shop).then((value) {
                  setState(() {
                    promo = value ?? PromoCheckOut(
                      promoValue: 0,
                      index: "0",
                      price: 10000.00 // a rediculous amount that should never be reached. if it is the customer needs help
                    );
                    promoStop++;
                    price.promo = promo.promoValue;
                  });
                });
              }
            }

        return Container(
          color: HexColor("#393939"),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Card(


                  child: Container(
                    color: Colors.red[900],
                    //color:HexColor("#393939"),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 0),
                        child: Text(
                          "Total = R ${
                              (calculateTotal(snapshot.data)).toStringAsFixed(2)
                                  }",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            letterSpacing: 3,

                          ),

                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width,

                  child: Card(
                    color: HexColor("#393939"),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Center(
                        child: Text(
                          "Promo: ${(promo.promoValue*100).toStringAsFixed(0)}% off",
                          style: TextStyle(
                            fontSize: 27,
                            color: Colors.white,
                            letterSpacing: 3,

                          ),

                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,

                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(

                                child: Card(
                                    color: Colors.grey[400],
                                 // color:Colors.white,

                                    child: ListTile(
                                      onTap: () {

                                      },
                                      //leading:Image.network(orders[index].image),
                                      //contentPadding: EdgeInsets.all(30),
                                      trailing: FlatButton.icon(
                                          onPressed: () async {
                                            await _auth.deleteFromDb(
                                                snapshot.data[index].title);
                                            setState(() {

                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                          ),
                                          label: Text("Remove")

                                      ),

                                      title: Column(
                                        children: [
                                          Text(
                                            snapshot.data[index].title ??
                                                "No title",


                                            style: TextStyle(
                                              fontSize: 25,
                                              //color:Colors.black,
                                              //decoration: TextDecoration.underline,

                                            ),

                                          ),
                                          SizedBox(
                                            height:MediaQuery.of(context).size.height/30,
                                          ),

                                          for(dynamic option in snapshot.data[index].mealOptions)
                                            Text(option.toString() ?? "")
                                        ],
                                      ),

                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data[index]
                                                .quantity} X R${snapshot
                                                .data[index].price}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.amber[800]
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),
                                    elevation: 0),
                              ),
                            ),

                          ],
                        );
                      }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        // underline: Container(
                        //   height: 5,
                        //   color: Colors.red,
                        // ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Cash','Card: total + 4 %']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),


                Container(
                  height: 50,
                  color: Colors.red[900],
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton.icon(
                            //color: Colors.green,
                          color:Colors.red[900],

                            onPressed: () async{
                              dynamic uid = await Auth().inputData();
                              shop = snapshot.data[0].shop;

                              final orders = snapshot.data;
                              final promoIndex = promo.index;
                              final isPromoApplied = promoApplied;
                              final String total = (calculateTotal(snapshot.data)*1.004).toStringAsFixed(2);
                              cardPaymentDetail cardPayment = cardPaymentDetail(
                                promoApplied: isPromoApplied,
                                promoIndex: promoIndex,
                                orders: orders,
                                promoValue: promo.promoValue
                              );




                              // Position position = await Geolocator().getCurrentPosition(
                              //     desiredAccuracy: LocationAccuracy.high);
                              // await Database().loadLocation(position.latitude, position.longitude);
                              // print(position.latitude);
                              // print(position.longitude);

                              if(dropdownValue=="Cash"){
                                for(int i =0;i<snapshot.data.length;i++){
                                  print("promo applied : $promoApplied");


                                  await Auth().checkOutApprovedCash(snapshot.data[i],promo.promoValue,promoIndex,isPromoApplied);

                                }

                                setState(() {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StreamProvider.value(
                                              value: AfterCheckOutState().getShopProgress(uid: uid),
                                              child: AfterCheckOut())
                                      )
                                  );
                                });

                              }
                              else{


        setState(() {
        Navigator.pop(context);
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => RedirectToOzow(amount: total,customerOrderDetail:cardPayment)
        )
        );
        });

        }
                              }


                              ,
                            icon: Icon(

                              Icons.add_shopping_cart,
                              color:Colors.white,
                              size: 30,

                            )
                            ,
                            label: Text(
                              "Check Out!",
                              style: TextStyle(
                                fontSize: 20,
                                color:Colors.white,
                              ),

                            )
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),

        );
      });
  }
}
