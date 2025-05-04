import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/content_screens/crear_mudanza_screen.dart';
import 'package:luggo/screens/content_screens/menu_mudanza_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'service_buttons.dart';

//************************************************************
// TO DO fer la db local q almacena mudances (items count)
//************************************************************

class HomeScreenContent extends StatefulWidget {
  final void Function()? onAvatarTap;
  const HomeScreenContent({super.key, this.onAvatarTap});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  late Future<List<Mudanza>> _futureMudanzas;
  Map<int, int> itemCounts = {};


  @override
  void initState() {
    super.initState();
    _futureMudanzas = _cargarMudanzas();
  }


  //************************************************************
  // CARGAR LAS MUDANZAS DE LA DB LOCAL
  //************************************************************
  Future<List<Mudanza>> _cargarMudanzas() async {
    final db = await DatabaseService.getDatabase();
    final mudanzas = await db.mudanzaDao.obtenerTodos();

    itemCounts.clear();

    for (final mudanza in mudanzas) {
      final count = await db.itemDao.contarItemsDeMudanza(mudanza.mudanzaId!);
      itemCounts[mudanza.mudanzaId!] = count ?? 0;
    }

    return mudanzas;
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
                child: FutureBuilder<String?>(
                  future: _getAvatarFileImatge(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    final url = snapshot.data;

                    return GestureDetector(
                      onTap: widget.onAvatarTap,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 35,
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

          SizedBox(
            height: 180,
            child: FutureBuilder<List<Mudanza>>(
              future: _futureMudanzas,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final mudanzas = snapshot.data!;

                return SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: mudanzas.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index < mudanzas.length) {
                        final mudanza = mudanzas[index];
                        return _mudanzaCard(
                          context,
                          mudanza,
                          0.0, // CALCULAR PROGRESO TO BE DONE
                        );
                      } else {
                        return _mudanzaCardAnadir(context);
                      }
                    },
                  ),
                );
              },
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

  Widget _mudanzaCard(BuildContext context, Mudanza mudanza, double progress) {
    String itemsCantidad =
        '${itemCounts[mudanza.mudanzaId] ?? 0} ${'items'.tr()}';

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MenuMudanzaScreen(idMudanza: mudanza.mudanzaId!),
          ),
        );

        if (result == true) {
          setState(() {
            _futureMudanzas = _cargarMudanzas();
          });
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Text(
                'mudanza'.tr() + mudanza.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),


            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                mudanza.imatge,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(
                    itemsCantidad,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'progressLabel'.tr(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.blue,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _mudanzaCardAnadir(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CrearMudanzaScreen()),
        );
        
        //refreshingggg
        if (resultado == true) {
          setState(() {
            _futureMudanzas = _cargarMudanzas();
          });
        }

      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha((0.08 * 255).round()),
          borderRadius: BorderRadius.circular(20),
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
          debugPrint('Error getting avatar: $e');
        }
      }
    }

    final connectivity = await Connectivity().checkConnectivity();
    final hasInternet = connectivity != ConnectivityResult.none;

    if (hasInternet && imageUrl != null && imageUrl.isNotEmpty) {
      return imageUrl;
    } else {
      return null;
    }
  }
}
