import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'aboutUs'.tr(),
          style: const TextStyle(
            fontFamily: 'ClashDisplay',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'whoWeAre'.tr(),
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'whoWeAreText'.tr(),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'whatWeOffer'.tr(),
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'whatWeOfferText'.tr(),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ourMission'.tr(),
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ourMissionText'.tr(),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'thankYou'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Image.asset(
                'assets/images/LuggoColor_noBackground.png',
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
