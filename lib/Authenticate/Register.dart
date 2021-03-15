import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Shared/Constants.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/States/RegisterState.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  @override
  Widget build(BuildContext context) {
   final registerState = Provider.of<RegisterState>(context);
    return registerState.loading
        ? Loading()
        : Scaffold(
            backgroundColor: HexColor("#393939"),

            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: registerState.formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                            child:Image(
                              image:AssetImage(
                                  "Picture/HalaLogo.jpeg"
                              ),
                            )
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Name"),
                        controller: registerState.name,
                        validator: (name){
                          return registerState.validateName(name);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Surname"),
                        controller: registerState.surname,
                        validator: (surname){
                          return registerState.validateSurname(surname);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Email"),
                        controller: registerState.emailValue,
                        validator: (val){
                          return registerState.validateEmail(val);
                        },
                        onChanged: (val) {
                          //returns a value each time the user types or deletes something
                          setState(() {
                            registerState.email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Password"),
                        controller: registerState.passwordOriginal,
                        validator: (password){
                          return registerState.validatePassword(password);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),

                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Confirm Password"),
                        controller: registerState.passwordConfirm,
                        validator: (val) {
                         return registerState.confirmPassword(val);
                        },
                        obscureText: true, // encrypts password
                        onChanged: (val) {
                          //returns a value each time the user types or deletes something
                          setState(() {
                            registerState.password = val;
                          });
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.01),
                      Text(
                        registerState.emailConfirmation,
                        style:TextStyle(
                          color:Colors.amber,
                          fontSize: 24
                        )
                      ),
                      RaisedButton(
                        onPressed: () async {

                          registerState.registerClicked();
                        },
                        color: Colors.black,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        registerState.error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
