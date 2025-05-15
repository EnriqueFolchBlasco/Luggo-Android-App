import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/screens/bottomMenu_screens/home_screen.dart';
import 'package:luggo/screens/bottomMenu_screens/services_screen.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/utils/constants.dart';

class ServiceConfirmationScreen extends StatefulWidget {
  final String serviceType;

  const ServiceConfirmationScreen({super.key, required this.serviceType});

  @override
  State<ServiceConfirmationScreen> createState() => _ServiceConfirmationScreenState();

  
}

class _ServiceConfirmationScreenState extends State<ServiceConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 18),
          icon: const Icon(Icons.menu),
          iconSize: 36,
          onPressed: () async {
            final result = await Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => const SideBarScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );

            if (result == true) {
              setState(() {});
            }
          },
        ),
        title: 
           
            Image(
              image: AssetImage('assets/images/LuggoColor_noBackground.png'),
              height: 28,
            ),
      ),
      // body: ...,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).viewPadding.bottom + 16,
        ),

        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServicesScreen(),
                ),
              );
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'next'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
