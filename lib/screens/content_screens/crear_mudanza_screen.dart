import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/custom_form_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearMudanzaScreen extends StatefulWidget {
  const CrearMudanzaScreen({super.key});

  @override
  State<CrearMudanzaScreen> createState() => _CrearMudanzaScreenState();
}

class _CrearMudanzaScreenState extends State<CrearMudanzaScreen> {
  final controlNombre = TextEditingController();
  final controlOrigen = TextEditingController();
  final controlDestino = TextEditingController();
  String estado = 'Planificada';

  @override
  void dispose() {
    controlNombre.dispose();
    controlOrigen.dispose();
    controlDestino.dispose();
    super.dispose();
  }

  Future<void> guardarMudanza() async {
    final nombre = controlNombre.text.trim();
    final origen = controlOrigen.text.trim();
    final destino = controlDestino.text.trim();

    if (nombre.isEmpty || origen.isEmpty || destino.isEmpty) {
      // TO DO
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseService.getDatabase();

    final defaultTabs = [
      'kitchen',
      'diningRoom',
      'bathroom',
    ];
    
    final tabsString = defaultTabs.map((key) => key.tr()).join('|');

    final nuevaMudanza = Mudanza(
      userId: prefs.getString('userUID') ?? '',
      nombre: nombre,
      fecha: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      direccionOrigen: origen,
      direccionDestino: destino,
      estado: estado,
      notas: '',
      mudanzaId: null,
      createdAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      updatedAt: null,
      isArchived: false,
      tabs: tabsString,
    );

    await db.mudanzaDao.insertar(nuevaMudanza);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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

            if (result == true) setState(() {});
          },
        ),
        title: Row(
          children: const [
            Spacer(),
            Image(
              image: AssetImage('assets/images/LuggoColor_noBackground.png'),
              height: 28,
            ),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Container(
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
                  const SizedBox(height: 20),
                  Text(
                    'CREAR MUDANZA'.tr(),
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            LuggoLabel('moveName'.tr()),
            LuggoTextField(
              controller: controlNombre,
              hint: 'enterMoveName'.tr(),
              maxLength: 20,
            ),

            LuggoLabel('originAddress'.tr()),
            LuggoTextField(
              controller: controlOrigen,
              hint: 'enterOrigin'.tr(),
              maxLength: 20,
            ),

            LuggoLabel('destinationAddress'.tr()),
            LuggoTextField(
              controller: controlDestino,
              hint: 'enterDestination'.tr(),
              maxLength: 20,
            ),

            Center(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: guardarMudanza,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: Colors.black12,
                  ),
                  child: Text(
                    'saveMove'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
