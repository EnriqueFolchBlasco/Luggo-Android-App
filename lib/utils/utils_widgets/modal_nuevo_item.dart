import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/models/item.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/custom_form_widgets.dart';

class ModalNuevoItem extends StatefulWidget {
  final int idMudanza;
  final List<Map<String, dynamic>> categorias;
  final String categoriaActual;
  final VoidCallback onItemGuardado;

  const ModalNuevoItem({
    super.key,
    required this.idMudanza,
    required this.categorias,
    required this.categoriaActual,
    required this.onItemGuardado,
  });

  @override
  State<ModalNuevoItem> createState() => _ModalNuevoItemState();
}

class _ModalNuevoItemState extends State<ModalNuevoItem> {
  final TextEditingController nombreCtrl = TextEditingController();
  late String categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    categoriaSeleccionada = widget.categoriaActual;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              'addItem'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),


            LuggoTextField(controller: nombreCtrl, hint: 'enterName'.tr()),



            DropdownButtonFormField<String>(
              value: categoriaSeleccionada,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    categoriaSeleccionada = value;
                  });
                }
              },
              
              items: widget.categorias.map((x) {
                return DropdownMenuItem<String>(
                  value: x["nombre"],
                  child: Text(x["nombre"].toString().tr(),

                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),




            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final nombre = nombreCtrl.text.trim();
                    if (nombre.isEmpty) return;

                    final db = await DatabaseService.getDatabase();
                    await db.itemDao.insertar(
                      Item(
                        mudanzaId: widget.idMudanza,
                        nombre: nombre,
                        gotIt: false,
                        categoria: categoriaSeleccionada,
                        estado: 'Normal',
                      ),
                    );

                    Navigator.pop(context);
                    widget.onItemGuardado();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: Text(
                    'save'.tr(),
                    style: const TextStyle(color: Colors.white),
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
