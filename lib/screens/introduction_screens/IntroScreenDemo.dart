import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:easy_localization/easy_localization.dart';

//https://pub.dev/packages/introduction_screen



class IntroLuggoScreen extends StatefulWidget {
  const IntroLuggoScreen({super.key});

  @override
  State<IntroLuggoScreen> createState() => _IntroLuggoScreenState();
}

class _IntroLuggoScreenState extends State<IntroLuggoScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onDone() {
    Navigator.of(context).pop(); // Or navigate to login/home
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: 'welcomeTitle'.tr(), // e.g., "Welcome to Luggo"
          body: 'welcomeBody'.tr(),   // e.g., "Organize your moves with ease"
          image: Image.asset('assets/images/LuggoIconoColor.png', height: 160),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: 'servicesTitle'.tr(), // e.g., "All-in-One Services"
          body: 'servicesBody'.tr(),   // e.g., "Transport, donations, assembly, recycling & more"
          image: Image.asset('assets/images/mudanza_background1.png', height: 160),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: 'startNowTitle'.tr(), // e.g., "Ready to simplify your move?"
          body: 'startNowBody'.tr(),   // e.g., "Start planning with Luggo today"
          image: Image.asset('assets/images/mudanza_background2.png', height: 160),
          decoration: _getPageDecoration(),
        ),
      ],
      onDone: _onDone,
      showSkipButton: true,
      skip: Text('skip'.tr()),
      next: const Icon(Icons.arrow_forward),
      done: Text('done'.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeColor: Colors.blueAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
