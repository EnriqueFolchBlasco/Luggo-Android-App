import 'dart:async';
import 'package:flutter/material.dart';
import 'package:luggo/screens/bottomMenu_screens/home_screen.dart';
import 'package:luggo/screens/introduction_screens/IntroScreenDemo.dart';
import 'package:luggo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/Luggo_Baseline2.PNG',
          width: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final loggedInBefore = prefs.getBool('loggedInBefore') ?? false;
    //final isRemembered = prefs.getBool('isRemembered') ?? false;
    final savedUID = prefs.getString('userUID');

    final introVista = prefs.getBool('introVista');


    Widget nextScreen;

    if (introVista == null || !introVista) {

      nextScreen = const IntroLuggoScreen();
    } else if (loggedInBefore && savedUID != null) {

      nextScreen = HomeScreen();
    } else {

      nextScreen = LoginScreen();
    }

    if (!mounted){
      return;
    } 

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) {
          return nextScreen;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
