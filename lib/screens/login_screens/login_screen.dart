import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'forgotPassword_Screen.dart';
import '../bottomMenu_screens/home_screen.dart';
import 'register_screen.dart';
import '../../services/shared_prefs_service.dart';
import '../../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/firebase_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _errorMensatge = "";



  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMensatge = ("errorEmptyFields").tr();
      });
      return;
    }

    if (!EmailValidator.validate(email)) {
      setState(() {
        _errorMensatge = ("errorInvalidEmail").tr();
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        final uid = userCredential.user!.uid;
        final firebaseController = FirebaseController();
        final username = await firebaseController.fetchUsername(uid);

        if (username != null) {
          final sharedPrefs = SharedPrefsService();
          await sharedPrefs.saveOfflineLoginData(uid, username, email);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        setState(() {
          _errorMensatge = ("errorEmailNotVerified").tr();
        });
      }
    } catch (e) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? loggedBefore = prefs.getBool('loggedInBefore');
      if (loggedBefore == true) {
        String? uid = prefs.getString('userUID');
        String? username = prefs.getString('username');

        if (uid != null && username != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
          return;
        }
      }

      setState(() {
        _errorMensatge = ("errorLoginFailed").tr() + e.toString();
      });
    }
}


  InputDecoration customInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset('assets/images/LuggoColor2.png', height: 50),
              const SizedBox(height: 20),
              Text(
                ('welcomeLuggo').tr(),
                style: const TextStyle(
                  fontFamily: 'ClashDisplay',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontFamily: 'Helvetica'),
                decoration: customInputDecoration(
                  hint: ('email').tr(),
                  icon: Icons.email,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                style: const TextStyle(fontFamily: 'Helvetica'),
                decoration: customInputDecoration(
                  hint: ('password').tr(),
                  icon: Icons.lock,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _errorMensatge = "";
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    ('forgotPassword').tr(),
                    style: const TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ),

              if (_errorMensatge.isNotEmpty)
                Text(
                  _errorMensatge,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  ('login').tr(),
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(('noAccount').tr()),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      ('register').tr(),
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
