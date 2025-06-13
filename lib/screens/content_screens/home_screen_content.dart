import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/mudanza_widgets/mudanzas_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'service_screens/services_widgets/service_buttons.dart';

class HomeScreenContent extends StatefulWidget {
  final void Function()? onAvatarTap;
  const HomeScreenContent({super.key, this.onAvatarTap});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  List<Mudanza> mudanzas = [];
  bool cargando = true;
  Map<int, int> itemCounts = {};


  @override
  void initState() {
    super.initState();
    _cargarMudanzas();
  }



  //************************************************************
  // CARGAR LAS MUDANZAS DE LA DB LOCAL
  //************************************************************
  Future<void> _cargarMudanzas() async {
    final db = await DatabaseService.getDatabase();
    final todas = await db.mudanzaDao.obtenerTodos();

    final counts = <int, int>{};
    
    for (final m in todas) {
      final count = await db.itemDao.contarItemsDeMudanza(m.mudanzaId!);
      counts[m.mudanzaId!] = count ?? 0;
    }

    setState(() {
      mudanzas = todas;
      itemCounts = counts;
      cargando = false;
    });
  }




  //CAMBAIR EL MENSATGE DE HOLA DEPENGUENT DEL DIA HGORA
  String _calcularMensatgeBenbinguda() {
    final hora = DateTime.now().hour;
    if (hora >= 6 && hora < 13) {
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
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("...");
                        }

                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        String name = snapshot.data ?? 'userName';

                        return Text(
                          name,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        );
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
                child: FutureBuilder<String?>(
                  future: _getAvatarFileImatge(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    final url = snapshot.data;

                    return GestureDetector(
                      onTap: widget.onAvatarTap,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40,
                        backgroundImage:
                            (url != null && url.isNotEmpty)
                                ? NetworkImage(url)
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

          const MudanzasList(),



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
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 60),
        ],
      ),
    );
  }

  Future<String?> _getAvatarFileImatge() async {
    final prefs = await SharedPreferences.getInstance();
    String? imageUrl = prefs.getString('profileImageUrl');

    if (imageUrl == null || imageUrl.isEmpty) {
      String? uid = prefs.getString('userUID');

      if (uid != null) {
        try {
          var userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();

          imageUrl = userDoc.data()?['profileImage'];

          if (imageUrl != null && imageUrl.isNotEmpty) {
            await prefs.setString('profileImageUrl', imageUrl);
          }
        } catch (e) {
          debugPrint('rrror en el avat: $e');
        }
      }
    }

    final connectivity = await Connectivity().checkConnectivity();
    final internetDisponible = connectivity != ConnectivityResult.none;

    if (internetDisponible && imageUrl != null && imageUrl.isNotEmpty) {
      return imageUrl;
    } else {
      return null;
    }
  }
}
