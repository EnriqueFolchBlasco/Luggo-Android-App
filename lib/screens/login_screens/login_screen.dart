import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:luggo/services/auth_manager.dart';
import 'package:luggo/screens/bottomMenu_screens/home_screen.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';
import 'forgotPassword_Screen.dart';
import 'register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/utils_widgets/custom_text_field.dart';

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
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        final uid = userCredential.user!.uid;
        final firebaseController = AuthManager();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                'LUGGO',
                style: const TextStyle(
                  fontFamily: 'ClashDisplay',
                  fontSize: 54,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),
              
              Text(
                ('welcomeLuggo').tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _emailController,
                hint: ('email').tr(),
                icon: Icons.email_outlined,
              ),
              
              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                hint: ('password').tr(),
                icon: Icons.lock_outline,
                isPassword: true,
                isPasswordVisible: _passwordVisible,
                togglePasswordVisibility: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),


              Center(
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
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 14,
                      color: AppColors.primaryColor.withOpacity(0.8),
                      decoration: TextDecoration.none,
                      height: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              if (_errorMensatge.isNotEmpty)
                Text(
                  _errorMensatge,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  ('login').tr(),
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ('noAccount').tr(),
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          ('register').tr(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 14,
                            color: AppColors.primaryColor.withOpacity(0.8),
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: Icon(Icons.arrow_forward,
                          size: 12,
                          color: AppColors.primaryColor.withOpacity(0.8),),
                        ),
                      ],
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
