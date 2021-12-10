import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Screen/SignUp/components/custom_alert_dialog.dart';
import 'package:login_app/Screen/Welcome/components/rounded_button.dart';
import 'package:login_app/constants.dart';
import 'package:login_app/logging.dart';
import 'package:f_grecaptcha/f_grecaptcha.dart';

const String SITE_KEY = "6LfWMhAbAAAAAO1LECJdm519tJ959FTIFsuzS8mV";

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key, this.title}): super(key: key);
  final String title;
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

enum _VerificationStep {
  SHOWING_BUTTON, WORKING, ERROR, VERIFIED
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _VerificationStep _step = _VerificationStep.SHOWING_BUTTON;
  var log = getLogger('ForgotPasswordScreen');

  void _startVerification() {
    if (verifyEmail(emailController.text)) {
      setState(() => _step = _VerificationStep.WORKING);

      FGrecaptcha.verifyWithRecaptcha(SITE_KEY).then((result) {
        setState(() => _step = _VerificationStep.VERIFIED);
      }, onError: (e, s) {
        print("Could not verify:\n$e at $s");
        setState(() => _step = _VerificationStep.ERROR);
      });
    } else {
      promptUser(context, "Incorrect Format!", "Email must be in the format of example@example.com");
      log.w("Wrong Email format");
    }
  }

  Future<void> resetPassword() async {
    await _firebaseAuth.sendPasswordResetEmail(email: emailController.text);
    log.i("Reset Password Email Sent!");
  }

  void promptUser(BuildContext context, String text, String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdvanceCustomAlert(
          text: text,
          body: body,
        );
      }
    );
  }

  bool verifyEmail(String value) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    var log = getLogger('ForgotPasswordScreen');
    Widget content;
    switch (_step) {
      case _VerificationStep.SHOWING_BUTTON:
        content = Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/forgot.png",
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.10,
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                child: SingleChildScrollView(
                  child: Column(
                    children:[
                      Text(
                        "Forgot your password?\nReset it here!",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Form(
                        child: buildEmailField(),
                      ),
                      RoundedButton(
                        text: "Verify Yourself",
                        press: (){
                          _startVerification();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ]
        );
        break;
      case _VerificationStep.WORKING:
        content = new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new CircularProgressIndicator(),
              Text("Trying to figure out whether you're human",
                style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ]
        );
        break;
      case _VerificationStep.VERIFIED:
          content = Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/forgot.png",
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.10,
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                child: SingleChildScrollView(
                  child: Column(
                    children:[
                      Text(
                        "Forgot your password?\nReset it here!",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Form(
                        child: buildEmailField(),
                      ),
                      RoundedButton(
                        text: "Reset your password",
                        press: () {
                          resetPassword();
                          log.i("Password has been reset");
                          promptUser(context, "Link Sent!", "Please check your email.");
                        },
                      ),
                    ],
                  ),
                ),
                ),
            ],
          );
          log.i("Successfully Verified reCaptcha!");
        break;
      case _VerificationStep.ERROR:
        content = new Text(
            "We could not verify that you're a human :( This can occur if you "
                "have no internet connection (or if you really are a a bot)."
        );
        log.i("Failed To Verified reCaptcha!");
    }

    return Scaffold(
        body: new Center(
          child: content,
        ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        labelStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 20, fontWeight: FontWeight.w900),
        hintStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 15, fontWeight: FontWeight.w900),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 30,
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: emailController,
    );
  }

  OutlineInputBorder outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: kPrimaryColour),
      gapPadding: 10,
    );
  }
}
