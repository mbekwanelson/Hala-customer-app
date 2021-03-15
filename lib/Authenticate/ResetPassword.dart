import "package:flutter/material.dart";
import 'package:mymenu/Navigate/Wrapper.dart';
import 'package:mymenu/Shared/Constants.dart';
import 'package:mymenu/States/ResetPasswordState.dart';

class ResetPassWord extends StatefulWidget {
  @override
  _ResetPassWordState createState() => _ResetPassWordState();
}

class _ResetPassWordState extends State<ResetPassWord> {

  ResetPasswordState _resetPasswordState = ResetPasswordState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Reset Password"),
      ),
      body: Container(
        child: Column(
          children: [
             Padding(
               padding: const EdgeInsets.all(20),
               child: Text("Forgot your password?"),
             ),
            TextFormField(
              decoration:
              textInputDecoration.copyWith(hintText: "Confirm Password"),
              controller: _resetPasswordState.email,


            ),
            FlatButton(
              child: Text("Submit"),
              onPressed: ()async{
                await _resetPasswordState.resetPassword();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>Wrapper()
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

