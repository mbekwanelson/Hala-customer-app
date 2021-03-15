
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Authenticate/ResetPassword.dart';
import 'package:mymenu/Navigate/Wrapper.dart';
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

    final singInState = Provider.of<SignInState>(context);


    //if loading is true  return loading widget
    return singInState.loading? Loading() :Scaffold(
         resizeToAvoidBottomInset: true,
      
      backgroundColor: HexColor("#393939"),
      body: Align(
        alignment:Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(

            padding:EdgeInsets.symmetric(vertical:20,horizontal: 50),
            child: Column(
              children: [



                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.6,
                    width: MediaQuery.of(context).size.width*0.6,

                   child:Image(
                     image:AssetImage(
                         "Picture/HalaLogo.jpeg"
                     ),
                   )
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Material(
                //     elevation: 4.0,
                //     shape: CircleBorder(),
                //     clipBehavior: Clip.hardEdge,
                //     color: Colors.black,
                //     child: Ink.image(
                //       image: AssetImage("Picture/HalaTransparent.jpeg"),
                //       fit: BoxFit.scaleDown,
                //       width: 300.0,
                //       height: 300.0,
                //       child: InkWell(
                //         onTap: () {},
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Container(
                //     child: Material(
                //       elevation: 4.0,
                //       shape: CircleBorder(),
                //       clipBehavior: Clip.hardEdge,
                //       color: Colors.transparent,
                //       child: Ink.image(
                //         image: AssetImage("Picture/HalaLogo.jpeg"),
                //         fit: BoxFit.scaleDown,
                //         width: 300.0,
                //         height: 300.0,
                //         child: InkWell(
                //           onTap: () {},
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Form(

                  key:singInState.formKey,
                  child:Column(
                    children: <Widget>[
                      SizedBox(
                        height:20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Email") ,
                        validator: (val){
                         return singInState.validateEmail(val);
                        },
                        onChanged: (val){
                          //returns a value each time the user types or deletes something
                          setState(() {
                            singInState.email = val;
                          });
                        },

                      ),
                      SizedBox(
                          height:20
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: "Password"),
                        validator: (val) {
                          return singInState.validatePassword(val);
                        },
                        obscureText: true,// encrypts password
                        onChanged: (val){
                          //returns a value each time the user types or deletes something
                          setState(() {
                            singInState.password = val;
                          });
                        },

                      ),
                      SizedBox(
                          height:25,

                      ),
                      Text(
                        singInState.error,
                        style:TextStyle(
                          color:Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height:25,

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlineButton(
                            borderSide: BorderSide(
                                color:Colors.grey
                            ),

                            shape:RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed:() async{

                              singInState.signInClicked();

                            },
                            color:Colors.black,
                            child:Text(
                              "Sign in",
                              style:TextStyle(
                                color:Colors.white,
                              ),
                            ),
                          ),

                          OutlineButton(
                            borderSide: BorderSide(
                                color:Colors.grey
                            ),

                            shape:RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed:() async{

                              widget.toggleView();
                              print("Clicked register");

                            },
                            color:Colors.black,
                            child:Text(
                              "Register",
                              style:TextStyle(
                                color:Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),



                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: FlatButton(
                    color: HexColor("#393939"),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassWord()));
                      } , child: Text(
                      "Forgot Password",
                    style: TextStyle(
                      color:Colors.amber
                    ),
                  )),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       height:MediaQuery.of(context).size.height*0.03,
                //       width:MediaQuery.of(context).size.height*0.03,
                //       child: Image(
                //         image: NetworkImage("https://www.duupdates.in/wp-content/uploads/2020/07/google.jpg"),
                //       ),
                //     ),
                //     FlatButton(
                //         height:MediaQuery.of(context).size.height*0.03,
                //         //color: Colors.white,
                //         onPressed: ()async{
                //           await singInState.handleGoogleSignIn();
                //         },
                //         child:Text(
                //           "Sign in with Google",
                //           style: TextStyle(
                //               color:Colors.white
                //           ),
                //         )
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left:15.0),
                //       child: Container(
                //         height:MediaQuery.of(context).size.height*0.03,
                //         width:MediaQuery.of(context).size.height*0.03,
                //         child: Image(
                //           image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Facebook_logo_36x36.svg/600px-Facebook_logo_36x36.svg.png"),
                //         ),
                //       ),
                //     ),
                //     FlatButton(
                //       height:MediaQuery.of(context).size.height*0.03,
                //       //color: Colors.white,
                //         onPressed: ()async{
                //           await singInState.signInFB();
                //         },
                //         child:Text(
                //           "Sign in with facebook",
                //           style: TextStyle(
                //               color:Colors.blue[800]
                //           ),
                //         )
                //     ),
                //   ],
                // ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
