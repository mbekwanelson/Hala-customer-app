import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Position currentUserPosition;

  @override
  void initState() {
    // TODO: implement initState

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      setState(() {
        currentUserPosition = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final optionsState = Provider.of<OptionsState>(context);
    final optionCategories = Provider.of<List<Option>>(context);

    return optionCategories == null && currentUserPosition == null
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            drawer: UserDrawer(),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBar(
                title: Text(
                  "Categories",
                  style: TextStyle(letterSpacing: 2, fontSize: 23),
                ),
                centerTitle: true,
                backgroundColor: Colors.grey[900],
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(2, 3, 2, 5),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('Picture/HalaLogo.jpeg'),
                      radius: 30,
                    ),
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                //width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Container(
                        child: Text(
                          "What would you like?",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 34,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Flexible(
                      fit: FlexFit.loose,
                      child: GridView.builder(
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: optionCategories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          //width:300,
                                          //height:600,
                                          margin: EdgeInsets.all(20),
                                          child: CircleAvatar(
                                            radius: 62,
                                            backgroundColor: Colors.black87,
                                            child: CircleAvatar(
                                              backgroundImage: Image.network(
                                                optionCategories[index].url,
                                                loadingBuilder: (context,
                                                    child, progress) {
                                                  return progress == null
                                                      ? child
                                                      : CircularProgressIndicator();
                                                },
                                              ).image,
                                              radius: 55,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            optionsState.logOptionScreen(
                                                optionCategories[index]
                                                    .category);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return MultiProvider(
                                                  providers: [
                                                    StreamProvider.value(
                                                      value: ShopsState().getShops(
                                                          category:
                                                              optionCategories[
                                                                      index]
                                                                  .category,
                                                          currentUserPosition:
                                                              currentUserPosition),
                                                    ),
                                                    ChangeNotifierProvider
                                                        .value(
                                                            value:
                                                                ShopsState()),
                                                  ],
                                                  child: Shops(
                                                    category:
                                                        optionCategories[index]
                                                            .category,
                                                  ));
                                            }));
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      optionCategories[index].category,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black87,
                                          letterSpacing: 2),
                                    ),
                                  ]),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
