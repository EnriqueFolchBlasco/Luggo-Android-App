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
  final _formKey = GlobalKey<FormState>();
  final _origenController = TextEditingController();
  final _destinoController = TextEditingController();
  String estado = 'pendiente';
  final prefs = SharedPreferences.getInstance();

  @override
  void dispose() {
    _origenController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  Future<void> _guardarMudanza() async {
    if (_formKey.currentState!.validate()) {
      //final db = await $FloorAppDatabase.databaseBuilder('luggo.db').build();
      final db = await DatabaseService.getDatabase();


      final sharedPrefs = await prefs;
      final nuevaMudanza = Mudanza(
        userId: sharedPrefs.getString('userUID') ?? '',

        fecha: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        direccionOrigen: _origenController.text,
        direccionDestino: _destinoController.text,
        estado: estado,
        mudanzaId: null,
      );

      await db.mudanzaDao.insertar(nuevaMudanza);
      Navigator.pop(context, true);
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dirección Origen:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _origenController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Dirección Destino:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _destinoController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
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
                  onPressed: _guardarMudanza,
                  child: const Text('Guardar mudanza'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
