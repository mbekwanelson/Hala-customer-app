import "package:flutter/material.dart";
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/Customer.dart';
import 'package:mymenu/Navigate/Wrapper.dart';
import 'package:mymenu/Shared/Constants.dart';
import 'package:mymenu/States/AfterCheckOutState.dart';
import 'package:mymenu/States/UserDrawerState.dart';
import 'package:provider/provider.dart';
import 'package:mymenu/Home/AfterCheckOut.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  Customer customer;
  String uid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserDrawerState().customerInfo().then((value) {
      customer = value;
    });
    setState(() {
      uid = Auth().inputData();
    });
    // Auth().inputData().then((value){
    //   setState(() {
    //     uid = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final userDrawerState = Provider.of<UserDrawerState>(context);
    userDrawerState.logUser();
    return Container(
      margin: EdgeInsets.only(right: 80),
      color: Colors.grey[800],
      child: ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              accountName: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(userDrawerState.name ?? "Nah"),
              ),
              accountEmail: Text(userDrawerState.email ?? "Nah"),
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("Picture/avatar.png"),
                backgroundColor: Colors.grey[400],
              ),
            ),
          ),

          ListTile(
            title: Text(
              "Sign out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Auth().signOut();
              Navigator.of(context).pop(); //closes menu in home pAGE
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wrapper()));
            },
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),

          TextFormField(
              controller: userDrawerState.promoCode,
              decoration:
                  textInputDecoration.copyWith(hintText: "Enter Promo code")),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              userDrawerState.validPromo ?? "",
              style: TextStyle(color: Colors.amber, fontSize: 15),
            ),
          ),
          FlatButton(
            onPressed: () async {
              //userDrawerState.findPromos();
              userDrawerState.verifyPromo();
            },
            child: Text("Submit"),
          ),
          // FlatButton(
          //   child:Text("Order Progress"),
          //   onPressed: ()async{
          //
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AfterCheckOut()));
          //
          //     Navigator.pop(context);
          //
          //   },
          // ),

          FlatButton(
              child: Text("Order Progress"),
              onPressed: () {
                print(uid);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamProvider.value(
                            value:
                                AfterCheckOutState().getShopProgress(uid: uid),
                            child: AfterCheckOut())));
              }),
        ],
      ),
    );
  }
}
