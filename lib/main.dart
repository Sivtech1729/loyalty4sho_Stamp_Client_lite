import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutterbarber/dashboard.dart';
import 'package:flutterbarber/ui/profile_details.dart';
import 'ui/scan_code.dart';
import 'ui/special_offer.dart';
import 'ui/authentication.dart';
import 'ui/splash_screen.dart';
import 'ui/forget_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

String name='';

class _MyAppState extends State<MyApp> {
  bool authentic = false;
  @override
  void initState() {
    super.initState();
    autoAuthenticate();
  }

  void autoAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear();
    String data = prefs.getString("email");
    if (data != null) {
      setState(() {
        authentic = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Router router = Router();
    router.define('/', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return SplashScreenPage();
        }));

    router.define('/forgot', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return ForgotPasswordPage();
        }));

    router.define('/auth', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          if (authentic)
            return HomePag();
          else
            return LoginAndSignupPage();
        }));
    router.define('/profileDetails', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return ProfileDetailsPage();
        }));
    router.define('/special', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return SpecialOfferPage();
        }));
    router.define('/scan', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return ScanCodeScreen();
        }));
    router.define('/home', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return HomePag();
        }));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'rotary',
        textTheme: TextTheme(body1: TextStyle(fontSize: 16.0)),
      ),
      onGenerateRoute: router.generator,
      // home: LoginAndSignupPage(),
    );
  }
}

