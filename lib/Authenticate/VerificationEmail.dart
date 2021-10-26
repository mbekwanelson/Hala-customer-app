import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';

class VerificationEmail extends StatefulWidget {
  @override
  _VerificationEmailState createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Verify Email",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "A verification link has been sent to your email",
                style: TextStyle(
                    color: Colors.white, letterSpacing: 2, fontSize: 29),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Check junk/Spam folder",
                style: TextStyle(
                    color: Colors.white, letterSpacing: 2, fontSize: 29),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "After verifying click Sign in",
                style: TextStyle(
                    color: Colors.white, letterSpacing: 2, fontSize: 29),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                  // color: Colors.white,
                  onPressed: () {
                    Auth().signOut();
                  },
                  child: Text("Sign In")),
            )
          ],
        ),
      ),
    );
  }
}
