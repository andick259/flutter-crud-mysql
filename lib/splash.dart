import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nearco/auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Duration for which the splash screen will be visible
  @override
  void initState() {
    super.initState();
    // Simulate a long running task
    Timer(Duration(seconds: 3), () {
      // After 3 seconds, navigate to the Login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(48, 56, 65, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your app logo or image here
            Image.asset(
              'assets/logo_nearco.png',
              scale: 4,
            ),
            SizedBox(height: 20),
            //CircularProgressIndicator(
            //  color: Colors.yellow,
            // ),
          ],
        ),
      ),
    );
  }
}
