import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/screens/content_screens/service_screens/service_terms_screen.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/comentari_usuari.dart';

class ServiceInfoScreen extends StatefulWidget {
  final String serviceType;

  const ServiceInfoScreen({super.key, required this.serviceType});

  @override
  State<ServiceInfoScreen> createState() => _ServiceInfoScreenState();

}

class _ServiceInfoScreenState extends State<ServiceInfoScreen> {
  
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      cambiarImage(widget.serviceType),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'serviceInfo'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "clashDisplay",
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cambiarInformacion(widget.serviceType),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: AppColors.primaryColor),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'userOpinions'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "clashDisplay",
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 110),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '9,1',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'clashDisplay',
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '• Excelente •',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'clashDisplay',
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '10 comentarios',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'clashDisplay',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  const ComentariUsuari(
                    avatarRuta: 'assets/images/user.png',
                    nombre: 'Cristina Olmos',
                    ubicacion: 'Madrid, Madrid',
                    fecha: '10/05/2025',
                    comentario: 'Muy puntuales y profesionales. Recogieron todo con mucho cuidado y se aseguraron de no dejar nada atrás. ¡Repetiré sin duda!',
                  ),

                  const ComentariUsuari(
                    avatarRuta: 'assets/images/user.png',
                    nombre: 'Pau Rovira Rosaleny',
                    ubicacion: 'València, Almussafes',
                    fecha: '06/12/2017',
                    comentario: 'El proceso fue muy sencillo desde la app. Me contactaron rápido y el servicio fue tal como lo describieron. Todo genial.',
                  ),

                  const ComentariUsuari(
                    avatarRuta: 'assets/images/user.png',
                    nombre: 'Barbara Folch',
                    ubicacion: 'València, València',
                    fecha: '23/04/2024',
                    comentario: 'Tenía dudas al principio, pero fueron súper amables. Llegaron a tiempo y se encargaron de todo. Muy recomendable',
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

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
                PageRouteBuilder(
                  pageBuilder:
                      (_, __, ___) => ServiceTermsScreen(serviceType: widget.serviceType),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
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

  String cambiarInformacion(String serviceType) {
    switch (serviceType) {
      case 'transportService':
        return 'transportServiceInfo'.tr();
      case 'laborService':
        return 'laborServiceInfo'.tr();
      case 'smallMoveService':
        return 'smallMoveServiceInfo'.tr();
      case 'storePickupService':
        return 'storePickupServiceInfo'.tr();
      case 'recyclingService':
        return 'recyclingServiceInfo'.tr();
      case 'donateService':
        return 'donateServiceInfo'.tr();
      default:
        return 'transportServiceInfo'.tr();
    }
  }

  String cambiarImage(String serviceType) {
    switch (serviceType) {
      case 'transportService':
        return 'assets/images/TransporteBackground.png';
      case 'laborService':
        return 'assets/images/LaborBackground.png';
      case 'smallMoveService':
        return 'assets/images/SmallMoveBackground.png';
      case 'storePickupService':
        return 'assets/images/StorePickupBackground.png';
      case 'recyclingService':
        return 'assets/images/RecyclingBackground.png';
      case 'donateService':
        return 'assets/images/DonateBackground.png';
      default:
        return 'assets/images/LuggoColor.png';
    }
  }



}

  

