import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  //filtro obtrinddre serveis
  Future<List<Map<String, dynamic>>> getUserServices(String userId) async {
    final datos = await FirebaseFirestore.instance
        .collection('services')
        .where('userId', isEqualTo: userId)
        .orderBy('creacionTimestamp', descending: true)
        .get();

    return datos.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      body: FutureBuilder<String?>(
        future: SharedPrefsService().getUserUUID(),
        builder: (context, userdatos) {

          if (userdatos.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final uid = userdatos.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: getUserServices(uid),
            builder: (context, servicesdatos) {

              if (servicesdatos.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (servicesdatos.hasError) {
                return const Center(child: Text('Error'));
              }

              final services = servicesdatos.data ?? [];

              return ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'myServicesTitle'.tr(),
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
                  ),
                  const SizedBox(height: 16),

                  if (services.isEmpty)

                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'noServices'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontFamily: 'clashDisplay',
                          ),
                        ),
                      ),
                    )
                    
                  else
                    ...services.map((service) => _construitService(
                          service['tipo'] ?? 'Tipo',
                          service['fecha'] ?? 'Fecha',
                          service['pago']?.toString() ?? '0',
                        )),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.support_agent, color: AppColors.primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'helpNeeded'.tr(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  
  Widget _construitService(String tipo, String fecha, String pago) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Icon(
              Icons.donut_large_rounded,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tipo.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'clashDisplay',
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'dateText'.tr(args: [fecha]),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontFamily: 'clashDisplay',
                    ),
                  ),

                  Text(
                    'paidText'.tr(args: [pago]),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'clashDisplay',
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }


}
