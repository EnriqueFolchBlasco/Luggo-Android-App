import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/screens/login_screens/login_screen.dart';
import 'package:luggo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//https://pub.dev/packages/introduction_screen



class IntroLuggoScreen extends StatefulWidget {
  const IntroLuggoScreen({super.key});

  @override
  State<IntroLuggoScreen> createState() => _IntroLuggoScreenState();
}

class _IntroLuggoScreenState extends State<IntroLuggoScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introVista', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: 'introWelcomeTitle'.tr(),
            body: 'introWelcomeBody'.tr(),
            image: Image.asset(
              'assets/images/LuggoIconoColor.png',
              height: 160,
            ),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: 'introServicesTitle'.tr(),
            body: 'introServicesBody'.tr(),
            image: Image.asset(
              'assets/images/Luggo_Baseline BN.png',
              height: 160,
            ),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: 'introStartNowTitle'.tr(),
            body: 'introStartNowBody'.tr(),
            image: Image.asset(
              'assets/images/Luggo_Baseline Color 1.png',
              height: 160,
            ),
            decoration: _getPageDecoration(),
          ),
        ],
        onDone: _onDone,
        showSkipButton: true,
        skip: Text(
          'skip'.tr(),
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        next: const Icon(Icons.arrow_forward, color: AppColors.primaryColor),
        done: Text(
          'done'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color.fromARGB(255, 153, 184, 238),
          activeColor: AppColors.primaryColor,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }


  PageDecoration _getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'ClashDisplay',
      ),
      bodyTextStyle: TextStyle(fontSize: 16.0, height: 1.5),
      imagePadding: EdgeInsets.all(24),
      contentMargin: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
