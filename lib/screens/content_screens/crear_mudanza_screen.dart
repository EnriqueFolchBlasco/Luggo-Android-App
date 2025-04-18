import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/database/app_database.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearMudanzaScreen extends StatefulWidget {
  const CrearMudanzaScreen({super.key});

  @override
  State<CrearMudanzaScreen> createState() => _CrearMudanzaScreenState();
}

class _CrearMudanzaScreenState extends State<CrearMudanzaScreen> {
  final controlOrigen = TextEditingController();
  final controlDestino = TextEditingController();
  String estado = 'pendiente';

  @override
  void dispose() {
    controlOrigen.dispose();
    controlDestino.dispose();
    super.dispose();
  }

  Future<void> guardarMudanza() async {
    String origen = controlOrigen.text.trim();
    String destino = controlDestino.text.trim();

    if (origen.isEmpty || destino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseService.getDatabase();

    final nuevaMudanza = Mudanza(
      userId: prefs.getString('userUID') ?? '',
      fecha: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      direccionOrigen: origen,
      direccionDestino: destino,
      estado: estado,
      mudanzaId: null,
    );

    await db.mudanzaDao.insertar(nuevaMudanza);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FF),
      appBar: AppBar(
        title: const Text('Nueva Mudanza'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dirección Origen:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: controlOrigen,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dirección Destino:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: controlDestino,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: guardarMudanza,
                child: const Text('Guardar mudanza'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
