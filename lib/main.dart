import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nearco/auth/login.dart';
import 'package:nearco/inside/home.dart';
import 'package:nearco/navigation_menu.dart';
import 'package:nearco/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString('apiKey') != null;
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearco',
      //theme: ThemeData(
      // primarySwatch: Colors.teal,
      // ),
      home: isLoggedIn ? NavigationMenu() : SplashScreen(),
    );
  }
}
