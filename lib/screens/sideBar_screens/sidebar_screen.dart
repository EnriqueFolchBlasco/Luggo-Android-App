import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luggo/services/auth_manager.dart';
import 'package:luggo/screens/login_screens/login_screen.dart';
import 'about_us_screen.dart';
import 'help_screen.dart';
import 'privacy_screen.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luggo/utils/constants.dart';

class SideBarScreen extends StatefulWidget {
  const SideBarScreen({super.key});

  @override
  State<SideBarScreen> createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  bool showLanguageMenu = false;
  late final AuthManager authManager = AuthManager();

  Future<void> _logout(BuildContext context) async {

    try {
      await authManager.logout();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error en logout')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.close, size: 40, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        title: 
           
            Image(
              image: AssetImage('assets/images/LuggoColor_noBackground.png'),
              height: 28,
            ),
            
          
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.settings_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text(
                'opciones'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.language_sharp,
                color: AppColors.primaryColor,
              ),
              title: Text(
                'idioma'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
              trailing: Icon(
                showLanguageMenu ? Icons.expand_less : Icons.expand_more,
                color: AppColors.primaryColor,
              ),
              onTap: () {
                setState(() {
                  showLanguageMenu = !showLanguageMenu;
                });
              },
            ),
            if (showLanguageMenu) _languageDropdown(context),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text(
                'privacidad'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                );
              },
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.help_outline,
                color: AppColors.primaryColor,
              ),
              title: Text(
                'ayuda'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
              },
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.info_outline,
                color: AppColors.primaryColor,
              ),
              title: Text(
                'sobreNosotros'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                );
              },
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: AppColors.primaryColor),
              title: Text(
                'logOut'.tr(),
                style: const TextStyle(
                  fontFamily: 'Helvetica-Light',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
              onTap: () {
                _logout(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  //*******************************************
  // CREACIÓ DEL MENU DE IDOMES
  //*******************************************

  Widget _languageDropdown(BuildContext context) {
    final idiomaActual = context.locale;

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryColor.withAlpha(102)),
        ),

        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: idiomaActual,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),

            onChanged: (Locale? locale) {
              if (locale != null) {
                setState(() {
                  context.setLocale(locale);
                  showLanguageMenu = false;
                });
              }
            },

            items: [
              DropdownMenuItem(
                value: const Locale('es'),
                child: Row(
                  children: [
                    const Text("🇪🇸 "),
                    const SizedBox(width: 6),
                    Text(
                      'spanish'.tr(),
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              
              DropdownMenuItem(
                value: const Locale('ca', 'valencia'),
                child: Row(
                  children: [
                    Image.asset('assets/flags/valencian.png', height: 20),
                    const SizedBox(width: 6),
                    Text(
                      'valencian'.tr(),
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),

              DropdownMenuItem(
                value: const Locale('en'),
                child: Row(
                  children: [
                    const Text("🇬🇧 "),
                    const SizedBox(width: 6),
                    Text(
                      'english'.tr(),
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
