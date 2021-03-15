import 'package:flutter/material.dart';
import 'package:mymenu/Models/Option.dart';
import 'package:mymenu/Models/Restuarant.dart';
import 'package:mymenu/Navigate/Director.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/Shared/UserDrawer.dart';
import 'package:mymenu/States/OptionsState.dart';
import 'package:mymenu/States/ShopsState.dart';
import 'package:provider/provider.dart';

import 'Shops.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  @override
  Widget build(BuildContext context) {
    final optionsState = Provider.of<OptionsState>(context);
    final optionCategories = Provider.of<List<Option>>(context);

    return optionCategories==null? Loading():Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: UserDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title:Text(
              "Categories",
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 23
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[900],
        ),
      ),
      body: SingleChildScrollView(

        child: Container(
          height:MediaQuery.of(context).size.height,
          //width: double.infinity,
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Container(
                  child: Text(
                    "What would you like?",
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 34,
                      letterSpacing: 3,
                    ),
                      ),
                ),
              ),
              SizedBox(
                height:40
              ),
              Flexible(
                fit: FlexFit.loose,
                child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: optionCategories.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,20,20),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                        Text(
                          optionCategories[index].category,
                          style: TextStyle(
                            fontSize:30,
                            color: Colors.amber,
                            letterSpacing: 2
                          ),
                        ),
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    //width:300,
                                    //height:600,
                                    margin:EdgeInsets.all(20),



                                    child: CircleAvatar(
                                      backgroundImage:NetworkImage(optionCategories[index].url ?? "https://www.bengi.nl/wp-content/uploads/2014/10/no-image-available1.png"),
                                      radius:55,
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      optionsState.logOptionScreen(optionCategories[index].category);


      Navigator.push(context,MaterialPageRoute(builder: (context){
        return  MultiProvider(
          providers: [
            StreamProvider.value(value: ShopsState().getShops(category:optionCategories[index].category)),
            ChangeNotifierProvider.value(value: ShopsState()),

          ],
            child: Shops(category:optionCategories[index].category ,));
      }
      )
      );


    // Navigator.push(context,MaterialPageRoute(builder: (context){
    //   return MultiProvider(
    //     providers:[StreamProvider<List<Restaurant>>.value(
    //         value: RestaurantState().numberRestaurants(),
    //     ),
    //       ChangeNotifierProvider.value(value: RestaurantState())],
    //     child: Resturants(category:optionCategories[index].category ,),
    //   );}));
//                                      return StreamProvider.value(
//                                          value: RestaurantState().numberRestaurants(),
//                                          child: Resturants()
//                                      );

    });
                                        }
                                  
                                        ,
                                ),
                              ),

                            ]
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
