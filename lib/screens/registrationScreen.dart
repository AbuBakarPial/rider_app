import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/screens/loginScreen.dart';
import 'package:rider_app/screens/main_screen.dart';
import 'package:rider_app/widgets/progressDialog.dart';

class RegistrationScreen extends StatelessWidget {
  static const screenID = 'register';
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
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
              'Register as Rider',
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
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                    controller: emailTextEditingController,
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
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
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
                      if (nameTextEditingController.text.length < 4) {
                        displayToast(
                            "Name must be at least 4 characters.", context);
                      } else if (!emailTextEditingController.text
                          .contains("@")) {
                        displayToast("Email address is not valid.", context);
                      } else if (phoneTextEditingController.text.isEmpty) {
                        displayToast("Phone Number is Necessary.", context);
                      } else if (passwordTextEditingController.text.length <
                          6) {
                        displayToast(
                            "Password must be at least 6 characters.", context);
                      } else {
                        registerNewUser(context);
                      }
                    },
                    color: Colors.yellow,
                    textColor: Colors.white,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          'Register',
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.screenID, (route) => false);
                    },
                    child: Text(
                      "Already have an account? Login here",
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog('Creating Account, Please Wait..!');
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errmsg) {
      displayToast("Error: " + errmsg.toString(), context);
      Navigator.pop(context);
    }))
        .user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim()
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToast("Account created successfully", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.screenID, (route) => false);
    } else {
      displayToast("Account has not been created", context);
      Navigator.pop(context);
    }
  }

  void displayToast(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
