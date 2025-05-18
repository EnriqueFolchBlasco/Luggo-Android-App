import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';

class ModalNuevaCategoria extends StatelessWidget {
  final int idMudanza;
  final VoidCallback onCategoriaCreada;

  const ModalNuevaCategoria({
    super.key,
    required this.idMudanza,
    required this.onCategoriaCreada,
  });

  @override
  Widget build(BuildContext context) {
    final nombreCtrl = TextEditingController();

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
            'newCategory'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nombreCtrl,
            decoration: InputDecoration(
              hintText: 'categoryName'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final newName = nombreCtrl.text.trim();

                      if (newName.isEmpty) return;

                      final db = await DatabaseService.getDatabase();
                      final mudanza = await db.mudanzaDao.obtenerPorId(
                        idMudanza,
                      );

                      if (mudanza == null) return;

                      final updatedTabs = (mudanza.tabs?.split('|') ?? []);

                      if (!updatedTabs.contains(newName)) {
                        updatedTabs.add(newName);
                        await db.mudanzaDao.actualizarTabs(
                          idMudanza,
                          updatedTabs.join('|'),
                        );
                      }

                      Navigator.pop(context);
                      onCategoriaCreada();
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
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      ),
    );
  }
}
