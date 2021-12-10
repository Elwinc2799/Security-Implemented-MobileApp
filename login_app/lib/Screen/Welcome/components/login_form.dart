import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Screen/Content/content_screen.dart';
import 'package:login_app/Screen/SignUp/components/custom_alert_dialog.dart';
import 'package:login_app/Screen/Welcome/components/rounded_button.dart';
import 'package:login_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_app/logging.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final List<String> errors = [];
  var log = getLogger('LoginForm');

  String email;
  String password;
  String animationType = "idle";
  SharedPreferences sharedPreferences;

  int trials = 3;

  static const int fiveMinutes = 5 * 60 * 1000;
  static const String lastAttemptKey = 'lastAttempt';

  Future<void> checkLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final int lastAttempt = sharedPreferences.getInt(lastAttemptKey);

    if (lastAttempt != null) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int difference = now - lastAttempt;

      if (difference >= fiveMinutes) {
        sharedPreferences.remove(lastAttemptKey);
        trials = 3;
        await signIn();
      } else {
        promptUser(context, "Limit Reached!", "You have to wait for 5 minutes after fail attempts.");
        log.w("Login Failure for 5 times! Time penalty: 5 minutes");
      }
    } else {
      await signIn();
    }
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

  Future<void> signIn() async {
    bool isGood = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      trials--;

      if (trials == 0)
        sharedPreferences.setInt(lastAttemptKey, DateTime.now().millisecondsSinceEpoch);
      log.w("Wrong Password Entered!");

      isGood = false;
      setState(() {
        animationType = "fail";
      });
    }

    if (isGood == true) {
      setState(() {
        animationType = "success";
      });

      log.i("Login into account...");

      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ContentScreen();
          },
        ));
      });
    }
  }

  bool checkNoSQLInjection() {
    String emailText = emailController.text;
    String passwordText = passwordController.text;
    String noSQLInjection = "db.";

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailText);

    if (emailValid)
      return (passwordText.contains(noSQLInjection)) ? false : true;
    else
      return false;
  }

  @override
  void initState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          animationType = "test";
        });
      }
      else {
        setState(() {
          animationType = "idle";
        });
      }
    });

    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        setState(() {
          animationType = "test";
        });
      }
      else {
        setState(() {
          animationType = "idle";
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: size.height * 0.3,
              width: size.width * 0.75,
              child: CircleAvatar(
                child: ClipOval(
                  child: FlareActor(
                    "assets/teddy_test.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: animationType,
                  ),
                ),
                backgroundColor: kPrimaryLightColour,
              )
          ),
          SizedBox(height: size.height * 0.05),
          Form(
            child: Column(
              children: [
                buildEmailField(),
                SizedBox(height: 3),
                buildPasswordField(),
                RoundedButton(
                  text: "Login",
                  press: () {
                    bool proceed = checkNoSQLInjection();

                    if (proceed)
                      checkLogin();

                    else
                      setState(() {
                        animationType = "fail";
                      });
                    // set logger here attempt login
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      maxLength: 15,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        labelStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 20, fontWeight: FontWeight.w900),
        hintStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 15, fontWeight: FontWeight.w900),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: passwordController,
      focusNode: passwordFocusNode,
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      maxLength: 30,
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
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: emailController,
      focusNode: emailFocusNode,
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