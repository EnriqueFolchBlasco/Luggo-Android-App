import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/screens/content_screens/service_screens/service_details_screen.dart';

import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/barra_progress.dart';

class ServiceTermsScreen extends StatefulWidget {
  final String serviceType;

  const ServiceTermsScreen({required this.serviceType});

  @override
  State<ServiceTermsScreen> createState() => _ServiceTermsScreenState();
}

class _ServiceTermsScreenState extends State<ServiceTermsScreen> {
  
  List<String> terms = [
    "1. All services are subject to availability and confirmation.",
    "2. The customer is responsible for ensuring accurate information is provided.",
    "3. Bookings must be made at least 24 hours in advance.",
    "4. Cancellations within 12 hours of the scheduled time may incur a fee.",
    "5. Prices include applicable taxes unless stated otherwise.",
    "6. Payment is processed securely through a third-party provider.",
    "7. In case of delay or no-show, no refunds will be issued.",
    "8. The company reserves the right to refuse service in cases of misconduct.",
    "9. Customer data is handled in accordance with our privacy policy.",
    "10. By continuing, you agree to our full terms and conditions.",
  ];


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
        title: Image(
          image: AssetImage('assets/images/LuggoColor_noBackground.png'),
          height: 28,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Column(
      children: [
        Center(
          child: Container(
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
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    widget.serviceType.tr(),
                    style: const TextStyle(
                      fontFamily: 'clashDisplay',
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  child: BarraProgressoAmazon(0),
                ),
                const SizedBox(height: 12),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...terms.map(
                    (texte) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          texte,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20,16,20,MediaQuery.of(context).viewPadding.bottom + 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsScreen(serviceType: widget.serviceType),
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
