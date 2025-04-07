import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          'help'.tr(),
          style: const TextStyle(
            fontFamily: 'ClashDisplay',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.support_agent, size: 50, color: AppColors.primaryColor),
            const SizedBox(height: 20),
            Text(
              'needHelp'.tr(),
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'helpText'.tr(),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'contactUs'.tr(),
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: support@luggo.com\nPhone: +34 640 000 099',
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
