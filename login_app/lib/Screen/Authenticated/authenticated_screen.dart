import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Screen/OhNo/oh_no_screen.dart';
import 'package:login_app/Screen/Welcome/components/rounded_button.dart';
import 'package:login_app/logging.dart';

class AuthenticatedScreen extends StatelessWidget {
  final firebaseAuth = FirebaseFirestore.instance.collection("users");
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var log = getLogger('AuthenticatedScreen');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/screen.png",
            fit: BoxFit.cover,
          ),
          Positioned(
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
              top: MediaQuery.of(context).size.height * 0.05,
              child: StreamBuilder(
                  stream: firebaseAuth.doc(firebaseUser.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      log.e("Connection to Firestore failed");
                      return SomethingWentWrongScreen();
                    }
                    if (snapshot.hasData) {
                      log.i("Connection to Firestore successfully");
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Text(
                              "PROFILE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              fontSize: 25, color: Colors.grey, letterSpacing: 2.0, fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.40
                          ),
                          Container(
                            width: double.infinity,
                            child: Container(
                              alignment: Alignment(0.0,2.5),
                              child: CircleAvatar(
                                child: Image.asset("assets/images/lion.png"),
                                radius: 30.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01
                          ),
                          Text(
                            snapshot.data['name'],
                            style: TextStyle(
                              fontFamily: "Comfortaa", fontSize: 25, color: Colors.blueGrey, letterSpacing: 2.0, fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01
                          ),
                          Text(
                            snapshot.data['age'].toString() + " y/o",
                            style: TextStyle(
                              fontFamily: "Comfortaa", fontSize: 18, color: Colors.black45, letterSpacing: 2.0, fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01
                          ),
                          Text(
                            snapshot.data['email'],
                            style: TextStyle(
                              fontFamily: "Comfortaa", fontSize: 18, color: Colors.black45, letterSpacing: 2.0, fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01
                          ),
                          Text(
                            snapshot.data['phone'],
                            style: TextStyle(
                              fontFamily: "Comforta", fontSize: 15, color: Colors.grey, letterSpacing: 2.0, fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05
                          ),
                          RoundedButton(
                            text: "Back",
                            press: () {
                              log.i("Review confidential data successfully");
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                    return Scaffold();
                  }))
        ],
      ),
    );
  }
}
