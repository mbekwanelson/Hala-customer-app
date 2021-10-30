// import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Authenticate/Authenticate.dart';
import 'package:mymenu/Authenticate/VerificationEmail.dart';
import 'package:mymenu/Home/Options.dart';
import 'package:mymenu/Models/User.dart';
import 'package:mymenu/States/OptionsState.dart';
import 'package:mymenu/States/UserDrawerState.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context); // acessing user data from
    var auth = Auth();

    // if it returns a user that means that that user is signed in (registered)
    try {
      auth.reloadUser().then((value) {});
      if (user == null) {
        // user not signed in
        return Authenticate();
      } else if (user.isEmailVerified == false) {
        return VerificationEmail();
      } else {
        // Bastard signed in!
        return MultiProvider(
          providers: [
            // StreamProvider.value(
            // value: RestaurantState().numberRestaurants()
            // ),
            ChangeNotifierProvider.value(value: UserDrawerState()),
            ChangeNotifierProvider.value(value: OptionsState()),
            StreamProvider.value(
                initialData: [], value: OptionsState().getOptions()),
          ],
          child: Options(),
        );
      }
    } catch (e) {
      return Authenticate();
    }
  }
}
