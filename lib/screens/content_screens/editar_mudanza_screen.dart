import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/custom_form_widgets.dart';


class EditarMudanzaScreen extends StatefulWidget {
  final Mudanza mudanza;

  const EditarMudanzaScreen({super.key, required this.mudanza});

  @override
  State<EditarMudanzaScreen> createState() => _EditarMudanzaScreenState();
}

class _EditarMudanzaScreenState extends State<EditarMudanzaScreen> {
  late TextEditingController _nombreCtrl;
  late TextEditingController _origenCtrl;
  late TextEditingController _destinoCtrl;
  late TextEditingController _estadoCtrl;

  int _itemsCount = 0;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.mudanza.nombre);
    _origenCtrl = TextEditingController(text: widget.mudanza.direccionOrigen);
    _destinoCtrl = TextEditingController(text: widget.mudanza.direccionDestino);
    _estadoCtrl = TextEditingController(text: widget.mudanza.estado);
    _loadItemsCount();
  }

  Future<void> _loadItemsCount() async {
    final db = await DatabaseService.getDatabase();
    final count = await db.inventarioDao.contarItemsDeMudanza(widget.mudanza.mudanzaId!);
    setState(() {
      _itemsCount = count!;
    });
  }

  Future<void> _guardarCambios() async {
    final db = await DatabaseService.getDatabase();

    final mudanzaActualizada = Mudanza(
      mudanzaId: widget.mudanza.mudanzaId,
      userId: widget.mudanza.userId,
      nombre: _nombreCtrl.text.trim(),
      fecha: widget.mudanza.fecha,
      direccionOrigen: _origenCtrl.text.trim(),
      direccionDestino: _destinoCtrl.text.trim(),
      estado: _estadoCtrl.text.trim(),
      createdAt: widget.mudanza.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      isArchived: widget.mudanza.isArchived,
    );

    await db.mudanzaDao.actualizar(mudanzaActualizada);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text('editMove'.tr()),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LuggoLabel('moveName'.tr()),
            LuggoTextField(controller: _nombreCtrl, hint: 'enterMoveName'.tr()),

            LuggoLabel('originAddress'.tr()),
            LuggoTextField(controller: _origenCtrl, hint: 'enterOrigin'.tr()),

            LuggoLabel('destinationAddress'.tr()),
            LuggoTextField(controller: _destinoCtrl, hint: 'enterDestination'.tr()),

            LuggoLabel('estado'.tr()),
            LuggoTextField(controller: _estadoCtrl, hint: 'inProgress'.tr()),

            const SizedBox(height: 20),
            Text('Items: $_itemsCount'),
            const SizedBox(height: 6),
            Text('Created: ${widget.mudanza.createdAt}',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text('Updated: ${widget.mudanza.updatedAt ?? "-"}',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _guardarCambios,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: Colors.black12,
                  ),
                child: Text('saveChanges'.tr(), style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
        )],
        ),
      ),
    );
  }
}
