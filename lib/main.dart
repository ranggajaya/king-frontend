import 'package:flutter/material.dart';
import 'package:king_frontend/screens/home/main_screen.dart';
import 'package:king_frontend/screens/sign_in_screen.dart';
import 'package:king_frontend/screens/sign_up_screen.dart';
import 'package:king_frontend/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/sign-in': (context) => SigninScreen(),
        '/sign-up': (context) => SignupScreen(),
        '/home': (context) => MainScreen(),
      },
    );
  }
}
