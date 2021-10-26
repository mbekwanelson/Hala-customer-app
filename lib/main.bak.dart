import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Navigate/Wrapper.dart';
import 'package:mymenu/Notifications/PushNotificationsManager.dart';
import 'package:provider/provider.dart';

//import 'package:here_sdk/core.dart';
import 'Services/firebase_analytics.dart';

void main() {
  //SdkContext.init(IsolateOrigin.main);
  WidgetsFlutterBinding.ensureInitialized(); //helps with multiprovider
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorObservers: [observer],
    home: Main(analytics: analytics, observer: observer),
  ));
}

class Main extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  Main({this.analytics, this.observer});
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
  Future _sendAnalytics() async {
    await widget.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _currentScreen();
    _sendAnalytics();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User>.value(
      //providing stream to root widget
      //actively listening to auth requests user sign in/out
      value: Auth().user, // whether user signed in or not
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: double.infinity,
          width: 900,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
          ),
        ),
      ),
    );
  }
}
