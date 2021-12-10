import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:login_app/Screen/ForgotPassword/forgot_screen.dart';
import 'package:login_app/Screen/OhNo/oh_no_screen.dart';
import 'package:login_app/Screen/SMSTac/sms_screen.dart';
import 'package:login_app/Screen/Welcome/components/body.dart';
import 'package:login_app/logging.dart';

class WelcomeScreen extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  var log = getLogger('WelcomeScreen');

  final pages = [
    Scaffold(resizeToAvoidBottomInset: false, body: LogConsoleOnShake(child: Body())),
    ForgotPasswordScreen(),
    SMSTacScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // set logger here cannot connect
          log.e("Connection Failed");
          return SomethingWentWrongScreen();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // set logger connection done
          log.i("Connection Done");
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return Builder(
                builder: (context) => LiquidSwipe(pages: pages),
              );
            },
          );
        }

        // set logger here conencting
        log.v("Connecting...");
        return Scaffold(

        );
      },
    );
  }
}