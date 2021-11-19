import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mymenu/Authenticate/ResetPassword.dart';
import 'package:mymenu/Shared/Constants.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/States/SignInState.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    // print("Sigin in build");
    final singInState = Provider.of<SignInState>(context);
    // print("Sign in state: ${singInState}");

    //if loading is true  return loading widget
    return singInState.loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,

            //backgroundColor: HexColor("#393939"),
            body: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("Picture/hala_sign_in.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: singInState.formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email_outlined)),
                                validator: (val) {
                                  return singInState.validateEmail(val);
                                },
                                onChanged: (val) {
                                  //returns a value each time the user types or deletes something
                                  setState(() {
                                    singInState.email = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.vpn_key)),
                                validator: (val) {
                                  return singInState.validatePassword(val);
                                },
                                obscureText: true, // encrypts password
                                onChanged: (val) {
                                  //returns a value each time the user types or deletes something
                                  setState(() {
                                    singInState.password = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Text(
                                singInState.error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            side: BorderSide(
                                                color: Colors.black87)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              HexColor("#393939")),
                                    ),
                                    onPressed: () async {
                                      print("Sign in btn clicked");
                                      singInState.signInClicked();
                                    },
                                    //color:Colors.black,
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            side: BorderSide(
                                                color: Colors.black87)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              HexColor("#393939")),
                                      //backgroundColor: HexColor("#393939")
                                    ),
                                    onPressed: () async {
                                      print("register btn clicked");
                                      widget.toggleView();
                                    },
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: FlatButton(
                            color: HexColor("#393939"),
                            onPressed: () {
                              print("forgot password btn clicked");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassWord()));
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(color: Colors.amber),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
