import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          'opciones'.tr(),
          style: const TextStyle(
            fontFamily: 'ClashDisplay',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.tune, size: 50, color: AppColors.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'settingsIntro'.tr(),
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.notifications_none, color: AppColors.primaryColor),
            title: Text(
              'notificationSettings'.tr(),
              style: const TextStyle(fontFamily: 'Helvetica'),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security_outlined, color: AppColors.primaryColor),
            title: Text(
              'securitySettings'.tr(),
              style: const TextStyle(fontFamily: 'Helvetica'),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
