import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/screens/content_screens/service_buttons.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//************************************************************
// TO DO fer la db local q almacena mudances (items count)
//************************************************************

class HomeScreenContent extends StatelessWidget {
  //CAMBAIR EL MENSATGE DE HOLA DEPENGUENT DEL DIA HGORA
  String _calcularMensatgeBenbinguda() {
    final hora = DateTime.now().hour;

    if (hora >= 6 && hora < 13) {
      //print(hora.toString());
      return 'greeting1'; //dia
    } else if (hora >= 13 && hora < 21) {
      return 'greeting2'; //vesprada
    } else {
      return 'greeting3'; //nit
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          //************************************************************
          // DIR MATI VESPRA O NIT + AVATAR
          //************************************************************
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _calcularMensatgeBenbinguda().tr(),
                      style: const TextStyle(
                        fontFamily: 'ClashDisplay',
                        height: 1.1,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),

                    FutureBuilder<String?>(
                      future: SharedPrefsService().getUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("...");
                        } else if (snapshot.hasError) {
                          return const Text("Error");
                        } else {
                          return Text(
                            snapshot.data ?? 'userName',
                            style: const TextStyle(
                              fontFamily: 'ClashDisplay',
                              height: 1.1,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                              letterSpacing: 2,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: FutureBuilder<File>(
                  future: _getLocalAvatarFile(),
                  builder: (context, snapshot) {
                    final file = snapshot.data;

                    return GestureDetector(
                      onTap: () {
                          // TO DO REDIRIGIR A LA PANTALLA DE PERFIL
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 35,
                        backgroundImage:
                            (file != null && file.existsSync())
                                ? FileImage(file)
                                : const AssetImage(
                                      'assets/images/LuggoIconoColor.png',
                                    )
                                    as ImageProvider,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //************************************************************
          // PART DE LES CARTES
          //************************************************************
          Text(
            'yourMoves'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'yourMovesSubtitle'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'Helvetica',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                //TO DO CREAR ANTES QUE TOT TARGETA DE AÑADIR MUDANZA
                _mudanzaCard(context, 'Mudanza Bilbao', 64, 0.75),
                const SizedBox(width: 12),
                _mudanzaCard(context, 'Mudanza Castellón', 32, 0.4),
                const SizedBox(width: 12),
                _mudanzaCardAnadir(context),
              ],
            ),
          ),
          const SizedBox(height: 32),

          //************************************************************
          // SERVEIS
          //************************************************************
          Text(
            'needMoveHelp'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'moveHelpText'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'Helvetica',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          const ServiceButtonsGrid(),
        ],
      ),
    );
  }

  //************************************************************
  // CARTA ESTRUCTURA
  // TODO FER EL PRESS/ON TAP
  //************************************************************

  Widget _mudanzaCard(
    BuildContext context,
    String title,
    int items,
    double progress,
  ) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Helvetica',
              fontSize: 16,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),

                  //*************************************************************
                  // (!) DECIDIR COLOR CONTAINER ITEMS
                  //*************************************************************
                  border: Border.all(color: Colors.grey.shade300),

                  //border: Border.all(color: AppColors.primaryColor),
                ),
                child: Text(
                  '$items items',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text('progressLabel'.tr(), style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),

          //************************************************************
          // BARRAA
          //************************************************************
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.primaryColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _getLocalAvatarFile() async {
    final prefs = await SharedPreferences.getInstance();
    final imageUrl = prefs.getString('profileImageUrl');
    final dir = await getApplicationDocumentsDirectory();
    final localFile = File('${dir.path}/avatar.jpg');

    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final response = await HttpClient().getUrl(Uri.parse(imageUrl));
        final result = await response.close();

        if (result.statusCode == 200) {
          //200 = ok 400 error 500 = server error
          final bytes = await consolidateHttpClientResponseBytes(result);
          await localFile.writeAsBytes(bytes, flush: true);
          return localFile;
        }
      }
    } catch (_) {}

    return localFile;
  }

  Widget _mudanzaCardAnadir(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TO DO AÑADIR MUDANZA NOVA
        //Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMoveScreen()));},
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha((0.08 * 255).round()),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withAlpha(40)),
        ),
        child: const Center(
          child: Icon(
            Icons.add_outlined,
            size: 50,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
