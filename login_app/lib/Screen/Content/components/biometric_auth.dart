import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_app/Screen/Authenticated/authenticated_screen.dart';
import 'package:login_app/Screen/SignUp/components/custom_alert_dialog.dart';

class BiometricAuth extends StatefulWidget {
  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  LocalAuthentication localAuthentication = LocalAuthentication();

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

  Future<void> _authenticateFingerprint() async {
    bool _canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    if (!_canCheckBiometrics)
      promptUser(context, "Not Available!", "Your device does not support fingerprint biometrics.");

    bool _authenticated = false;
    try {
      _authenticated = await localAuthentication.authenticate(
        localizedReason: "Please authenticate to proceed.",
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (_authenticated) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticatedScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () { _authenticateFingerprint(); },
      child: SvgPicture.asset("assets/images/user.svg", fit: BoxFit.contain),
      shape: CircleBorder(side: BorderSide(color: Color(0xFF979797))),
    );
  }
}

