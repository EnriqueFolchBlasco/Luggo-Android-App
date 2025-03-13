import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
//0.7

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isRemembered = prefs.getBool('isRemembered') ?? false;

  String? savedUID = prefs.getString('userUID');
  

  runApp(MyApp(isRemembered: isRemembered, savedUID: savedUID));
}

class MyApp extends StatelessWidget {
  final bool isRemembered;
  final String? savedUID;

  const MyApp({super.key, required this.isRemembered, this.savedUID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luggo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isRemembered && savedUID != null ? HomeScreen() : LoginScreen(),
    );
  }
}
