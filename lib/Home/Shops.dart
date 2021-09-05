
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
        backgroundColor: Colors.white,
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
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(2,5,2,5),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('Picture/HalaLogo.jpeg') ,
                    radius: 30,
                  ),
                )
              ]
          ),
        ),

        body: SafeArea(
          child: Column(
            children: [
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
                      color: Colors.amber[700]
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
                            Expanded(
                              child: Container(
                                //width:300,
                                //height:600,
                                margin:EdgeInsets.all(20),
                                child: CircleAvatar(
                                  radius: 62,
                                  backgroundColor: Colors.black87,
                                  child: CircleAvatar(
                                    backgroundImage: Image.network(
                                      shops[index].shopBackground,
                                      loadingBuilder: (context, child, progress) {
                                        return progress == null
                                            ? child
                                            : CircularProgressIndicator(color: Colors.red,);
                                      },
                                      errorBuilder: (context,object,stacktrace){
                                          return LinearProgressIndicator();
                                      },
                                    ).image,
                                    radius: 55,
                                  ),
                                ),
                                /*child:CircleAvatar(
                                  backgroundImage:NetworkImage(shops[index].shopBackground ?? "https://www.bengi.nl/wp-content/uploads/2014/10/no-image-available1.png"),
                                  radius:100,
                                ),*/
                              ),
                            ),
                            Text(
                              shops[index].shopName,
                              style: TextStyle(
                                fontSize:18,
                                color:Colors.black87,
                                letterSpacing: 3,
                              ),
                            )

                          ]
                        ),
                      ),
                    );
                    }
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
