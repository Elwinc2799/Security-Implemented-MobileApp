import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Screen/SignUp/components/custom_alert_dialog.dart';
import 'package:login_app/Screen/Welcome/components/rounded_button.dart';
import 'package:login_app/constants.dart';
import 'package:login_app/logging.dart';
import 'package:login_app/Screen/SMSTac/OTP_screen.dart';

class SMSTacScreen extends StatefulWidget {
  const SMSTacScreen({Key key}) : super(key: key);

  @override
  _SMSTacScreenState createState() => _SMSTacScreenState();
}

class _SMSTacScreenState extends State<SMSTacScreen> {
  final phoneController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    var log = getLogger('SMSTacScreen');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/SMSTac.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              children: [
                Text(
                  "Forgot Your Password?\nLogin With Your Number!",
                  style: TextStyle(
                    fontFamily: "Comfortaa",
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Form(
                  child: buildSMSTacField(),
                ),
                RoundedButton(
                  text: "Send SMS TAC",
                  press: () {
                    //    _signInWithPhoneNumber(); //send otp
                    log.i("SMS TAC has been sent");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OTPScreen(phoneController.text)));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildSMSTacField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Phone",
        hintText: "Enter your number",
        labelStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 20, fontWeight: FontWeight.w900),
        hintStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 15, fontWeight: FontWeight.w900),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 15,
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: phoneController,
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