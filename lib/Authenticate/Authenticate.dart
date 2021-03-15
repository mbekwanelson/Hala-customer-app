
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Authenticate/Register.dart';
import 'package:mymenu/Authenticate/SignIn.dart';
import 'package:mymenu/States/RegisterState.dart';
import 'package:mymenu/States/SignInState.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
// changes state
  }

  @override
  Widget build(BuildContext context) {
    print("Show Sign INNNNNN : ${showSignIn}");


    if(showSignIn){
      return ChangeNotifierProvider.value(
        value:SignInState(),
        child: Container(
          child:SignIn(toggleView: toggleView),
        ),
      );
    }
    else{
      return ChangeNotifierProvider.value(
        value:RegisterState(),
        child: Container(
          child:Register(toggleView:toggleView),
        ),
      );
    }

  }
}
