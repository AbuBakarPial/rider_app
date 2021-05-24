import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/screens/loginScreen.dart';
import 'package:rider_app/screens/main_screen.dart';
import 'package:rider_app/screens/registrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Brand-Regular",
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainScreen.screenID,
      routes: {
        LoginScreen.screenID: (_) => LoginScreen(),
        RegistrationScreen.screenID: (_) => RegistrationScreen(),
        MainScreen.screenID: (_) => MainScreen(),
      },
    );
  }
}
