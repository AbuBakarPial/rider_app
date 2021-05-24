import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/screens/registrationScreen.dart';
import 'package:rider_app/widgets/progressDialog.dart';

import '../main.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  static const screenID = 'login';
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35.0),
            Image(
              image: AssetImage("images/logo.png"),
              width: 390.0,
              height: 350.0,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1.0),
            Text(
              'Login as Rider',
              style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 1.0),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    elevation: 10.0,
                    onPressed: () {
                      if (!emailTextEditingController.text.contains("@")) {
                        displayToast("Email address is not valid.", context);
                      } else if (passwordTextEditingController.text.isEmpty) {
                        displayToast("Password is not valid.", context);
                      } else {
                        userSignIn(context);
                      }
                    },
                    color: Colors.yellow,
                    textColor: Colors.white,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          RegistrationScreen.screenID, (route) => false);
                    },
                    child: Text(
                      "Don't have account? Click here",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Brand Bold",
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void userSignIn(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog('Authenticating, Please Wait..!');
        });
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errmsg) {
      displayToast("Error: " + errmsg.toString(), context);
      Navigator.pop(context);
    }))
        .user;
    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          displayToast("LoggedIn successfully", context);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.screenID, (route) => false);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToast("Provide valid Name and Password", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToast("Create an account to Logged in.", context);
    }
  }

  void displayToast(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
