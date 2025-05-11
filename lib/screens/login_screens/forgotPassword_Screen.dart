import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String _message = "";

  void _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _message = "errorEmptyFields".tr();
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _message = "resetSuccess".tr();
      });
    } catch (e) {
      setState(() {
        _message = "${'resetError'.tr()} ${e.toString()}";
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
              'forgotTitle'.tr(),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                color: AppColors.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w200,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            CustomTextField(
              controller: _emailController,
              hint: ('email').tr(),
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'forgotSubtitle'.tr(),
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 13,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            const SizedBox(height: 10),

            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color:
                  
                      _message.contains("success") || _message.contains("¡")
                          ? Colors.green
                          : Colors.red,

                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'resetPassword'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'backLogin'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
