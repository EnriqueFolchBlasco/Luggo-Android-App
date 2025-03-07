import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
//0.1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isRemembered = prefs.getBool('isRemembered') ?? false;

  runApp(MyApp(isRemembered: isRemembered));
}

class MyApp extends StatelessWidget {
  final bool isRemembered;

  const MyApp({super.key, required this.isRemembered});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luggo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isRemembered ? HomeScreen() : LoginScreen(),
    );
  }
}
