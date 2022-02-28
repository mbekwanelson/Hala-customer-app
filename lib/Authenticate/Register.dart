import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
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
            backgroundColor: Color(0xFF393939),
            // backgroundColor: HexColor("#393939"),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("Picture/hala_sign_in.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                  key: registerState.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Name",
                            prefixIcon: Icon(Icons.account_circle_sharp)),
                        controller: registerState.name,
                        validator: (name) {
                          return registerState.validateName(name);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        //decoration: textInputDecoration.copyWith(hintText: "Surname"),
                        decoration: textInputDecoration.copyWith(
                            hintText: "Surname",
                            prefixIcon: Icon(Icons.account_circle_sharp)),
                        controller: registerState.surname,
                        validator: (surname) {
                          return registerState.validateSurname(surname);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email_outlined)),
                        controller: registerState.emailValue,
                        validator: (val) {
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
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.vpn_key)),
                        controller: registerState.passwordOriginal,
                        validator: (password) {
                          return registerState.validatePassword(password);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Confirm Password",
                            prefixIcon: Icon(Icons.vpn_key)),
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(registerState.emailConfirmation,
                          style: TextStyle(color: Colors.amber, fontSize: 24)),
                      TextButton(
                        onPressed: () async {
                          registerState.registerClicked();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(color: Colors.black87)),
                          ),
                          // backgroundColor: MaterialStateProperty.all<Color>(
                          //     HexColor("#393939")),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF393939)),
                        ),
                        //color: Colors.black,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.amber,
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
