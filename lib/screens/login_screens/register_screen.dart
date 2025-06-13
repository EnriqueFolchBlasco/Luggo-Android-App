import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/services/auth_manager.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/custom_text_field.dart'; // Import your custom textfield
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _errorMessage = "";

  void _register() async {
    String email = _emailController.text.trim();
    String confirmEmail = _confirmEmailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String username = _usernameController.text.trim();

    if (email.isEmpty ||
        confirmEmail.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        username.isEmpty) {
      setState(() {
        _errorMessage = "errorEmptyFields".tr();
      });
      return;
    }

    if (email != confirmEmail) {
      setState(() {
        _errorMessage = "errorEmailMismatch".tr();
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "errorPasswordMismatch".tr();
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();

        final uid = userCredential.user!.uid;
        final firebaseController = AuthManager();
        await firebaseController.saveUserToFirestore(uid, email, username);

        final sharedPrefs = SharedPrefsService();
        await sharedPrefs.saveOfflineLoginData(uid, username, email);

        setState(() {
          _errorMessage = "registerSuccess".tr();
        });

        await Future.delayed(Duration.zero);
        await Future.delayed(const Duration(seconds: 3));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = "${'errorLoginFailed'.tr()} ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Text(
              'LUGGO',
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),

              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
                splashRadius: 20,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'registerTitle'.tr(),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                color: AppColors.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w200,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: _usernameController,
              hint: ('user').tr(),
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 35),

            CustomTextField(
              controller: _emailController,
              hint: ('email').tr(),
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _confirmEmailController,
              hint: ('confirmEmail').tr(),
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 35),

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
            const SizedBox(height: 16),

            CustomTextField(
              controller: _confirmPasswordController,
              hint: ('confirmPassword').tr(),
              icon: Icons.lock_outline,
              isPassword: true,
              isPasswordVisible: _confirmPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(
                  color:
                      _errorMessage.contains("success")
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'register'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Helvetica',
                  
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'haveAccount'.tr(),
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        'login'.tr(),
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                          color: AppColors.primaryColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
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
    );
  }
}
