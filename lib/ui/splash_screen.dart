import 'dart:async';
import '../services/cognito_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenState extends StatefulWidget {
  @override
  SplashScreen createState() => SplashScreen();
}

class SplashScreen extends State<SplashScreenState> {
  final cognitoService = CognitoService();

  @override
  void initState() {
    super.initState();
    showScreen();
  }

  showScreen() {
    Timer(Duration(milliseconds: 750), () {
      navigateUser();
    });
  }

  navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/splash_screen.jpg"),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
