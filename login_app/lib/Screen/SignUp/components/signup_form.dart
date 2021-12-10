import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hb_check_code/hb_check_code.dart';
import 'package:login_app/Screen/SignUp/components/captcha_divider.dart';
import 'package:login_app/Screen/SignUp/components/custom_alert_dialog.dart';
import 'package:login_app/Screen/Welcome/components/rounded_button.dart';
import 'package:login_app/constants.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_app/logging.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final captchaController = TextEditingController();
  List<String> attachments = [];
  String _captcha = randomAlpha(5);
  SharedPreferences sharedPreferences;

  int trials = 3;

  static const int fiveMinutes = 5 * 60 * 1000;
  static const String lastAttemptKey = 'lastAttempt';

  bool passwordConfirmation() {
    return passwordController.text == confirmPasswordController.text;
  }

  bool validatePassword(String value){
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validateEmail(String value) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
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

  Future<void> checkSignUp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final int lastAttempt = sharedPreferences.getInt(lastAttemptKey);
    var log = getLogger('SignUpForm');

    if (lastAttempt != null) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int difference = now - lastAttempt;

      if (difference >= fiveMinutes) {
        sharedPreferences.remove(lastAttemptKey);
        trials = 3;
        await checkValidity();
      } else {
        promptUser(context, "Limit Reached!", "You have to wait for 5 minutes after fail attempts.");
        // set logger here (warning 5 times)
        log.w("Login Failure : 5");
      }
    } else {
      await checkValidity();
    }
  }

  Future<void> checkValidity() async {
    bool isGood = true;
    var log = getLogger('SignUpForm');
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password')
        promptUser(context, "Weak Password!", "Please use a strong password.");
      else if (e.code == 'email-already-in-use')
        promptUser(context, "Email Existed!", "Please enter a new email.");

      isGood = false;
      trials--;
      if (trials == 0)
        sharedPreferences.setInt(lastAttemptKey, DateTime.now().millisecondsSinceEpoch);

      // set logger here with e.code
    } catch (e) {
      isGood = false;

      trials--;
      if (trials == 0)
        sharedPreferences.setInt(lastAttemptKey, DateTime.now().millisecondsSinceEpoch);

      // set logger here error while signing up
      log.e("Error detected while signing up");
    }

    if (isGood == true) {
      Navigator.pop(context);
      // set logger here sign up ssful
      log.i("Sign Up Successfully");
      promptUser(context, "Success!", "Please log in with your credentials.");
    }
  }

  void signUpOnPressed() {
    bool correctEmail = validateEmail(emailController.text);
    bool correctPassword = validatePassword(passwordController.text);
    var log = getLogger('SignUpForm');

    if (correctEmail && correctPassword) {
      if (passwordConfirmation() == true) {
        if (emailController.text.isNotEmpty) {
          if (captchaController.text.toLowerCase() != _captcha.toLowerCase()) {
            promptUser(context, "Wrong Captcha", "Please enter a valid captcha.");

            trials--;
            if (trials == 0)
              sharedPreferences.setInt(lastAttemptKey, DateTime.now().millisecondsSinceEpoch);

            log.w("Wrong Captcha has been inputs");
          } else {
            checkValidity();
          }
        }
      } else {
        trials--;
        if (trials == 0)
          sharedPreferences.setInt(lastAttemptKey, DateTime.now().millisecondsSinceEpoch);

        promptUser(context, "Wrong Password!", "Password must be the same.");
        log.w("Password does not matched");
      }
    } else {
      trials--;
      if (trials == 0)
        sharedPreferences.setInt(lastAttemptKey, DateTime.now().millisecondsSinceEpoch);

      if (!correctEmail) {
        promptUser(context, "Incorrect Format!", "Email must be in the format of example@example.com");
        log.w("Wrong Email format");
      }

      else if (!correctPassword) {
        promptUser(context, "Weak Password or wrong!", "Password must contain upper and lowercase, digits, special characters of 8");
        log.w("Weak Password detected");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      child: Column(
        children: [
          buildEmailField(),
          SizedBox(height: size.height * 0.025),
          buildPasswordField(),
          SizedBox(height: size.height * 0.025),
          buildConfirmPasswordField(),
          SizedBox(height: size.height * 0.02),
          CaptchaDivider(),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: HBCheckCode(
                  code: _captcha,
                )
              ),
              InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Icon(Icons.refresh)
              ),
            ],
          ),
          buildCaptchaField(),
          SizedBox(height: size.height * 0.01),
          RoundedButton(
            text: "Sign up",
            press: () { signUpOnPressed(); },
          )
        ],
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        counterText: "",
        labelText: "Password",
        hintText: "Enter your password",
        labelStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 20, fontWeight: FontWeight.w900),
        hintStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 15, fontWeight: FontWeight.w900),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 15,
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: passwordController,
    );
  }

  TextFormField buildConfirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        counterText: "",
        labelText: "Confirm Password",
        hintText: "Confirm your password",
        labelStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 20, fontWeight: FontWeight.w900),
        hintStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 15, fontWeight: FontWeight.w900),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 15,
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: confirmPasswordController,
    );
  }

  TextFormField buildCaptchaField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Captcha",
        hintText: "Enter the captcha",
        labelStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 20, fontWeight: FontWeight.w900),
        hintStyle: TextStyle(fontFamily: 'Comfortaa', fontSize: 15, fontWeight: FontWeight.w900),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 15),
      controller: captchaController,
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        counterText: "",
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
