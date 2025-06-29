import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/editar_mudanza_screen.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/inventario_screen.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/notas_mudanza.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/generar_pdf.dart';

class MenuMudanzaScreen extends StatefulWidget {
  final int idMudanza;

  const MenuMudanzaScreen({super.key, required this.idMudanza});

  @override
  State<MenuMudanzaScreen> createState() => _MenuMudanzaScreenState();
}

class _MenuMudanzaScreenState extends State<MenuMudanzaScreen> {
  Mudanza? mudanza;

  @override
  void initState() {
    super.initState();
    _cargarMudanza();
  }

  Future<void> _cargarMudanza() async {
    final db = await DatabaseService.getDatabase();
    final m = await db.mudanzaDao.obtenerPorId(widget.idMudanza);
    setState(() {
      mudanza = m;
    });
  }

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
            if (result == true) setState(() {});
          },
        ),
        title: 
           
            Image(
              image: AssetImage('assets/images/LuggoColor_noBackground.png'),
              height: 28,
            ),
      ),
      body:
          mudanza == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const SizedBox(height: 16),
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
                        Navigator.pop(context, true);
                      },
                      splashRadius: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    'moveOptions'.tr().toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'clashDisplay',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    mudanza!.nombre.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.blueGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          _crearOpcio(
                            Icons.inventory_2_outlined,
                            'Inventory',() {

                              final tabs = (mudanza!.tabs ?? '')
                                      .split('|')
                                      .map((e) => e.trim())
                                      .where((e) => e.isNotEmpty)
                                      .toList();

                              if (tabs.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Text('warning'.tr()),
                                        content: Text(
                                          'atLeastOneCategoryMustExist'.tr(),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text('ok'.tr()),
                                          ),
                                        ],
                                      ),
                                );
                                return;
                              }



                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => InventarioScreen(
                                        idMudanza: widget.idMudanza,
                                      ),
                                ),
                              );
                            },
                          ),
                          _crearOpcio(
                            Icons.mode_edit_outlined,
                            'Edit',
                            () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditarMudanzaScreen(
                                        mudanza: mudanza!,
                                      ),
                                ),
                              );

                              if (result == true) {
                                _cargarMudanza();
                              }
                            },
                          ),
                          _crearOpcio(
                            Icons.sticky_note_2_outlined,
                            'Notes',
                            () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        NotasMudanzaScreen(mudanzaId: widget.idMudanza),
                              ),
                            );

                            },
                          ),
                          _crearOpcio(Icons.qr_code_2, 'Labeling', () {
                            _generarPdfConEtiquetas();
                          }),
                          _crearOpcio(Icons.share, 'Share', () {}),
                          _crearOpcio(
                            Icons.delete_outline,
                            'Delete',
                            _confirmarBorradoMudanza,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Future<void> _confirmarBorradoMudanza() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('deleteMoveTitle'.tr()),
            content: Text('deleteMoveConfirm'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'delete'.tr(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final db = await DatabaseService.getDatabase();
      final mudanza = await db.mudanzaDao.obtenerPorId(widget.idMudanza);

      if (mudanza != null) {
        final mudanzaArchivada = Mudanza(
          mudanzaId: mudanza.mudanzaId,
          userId: mudanza.userId,
          nombre: mudanza.nombre,
          fecha: mudanza.fecha,
          notas: mudanza.notas,
          direccionOrigen: mudanza.direccionOrigen,
          direccionDestino: mudanza.direccionDestino,
          estado: mudanza.estado,
          createdAt: mudanza.createdAt,
          updatedAt: DateTime.now().toIso8601String(),
          isArchived: true,
          tabs: mudanza.tabs,
          imatge: mudanza.imatge,
        );

        await db.mudanzaDao.actualizar(mudanzaArchivada);
        Navigator.pop(context, true);
      }
    }
  }

  Widget _crearOpcio(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.08)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: AppColors.primaryColor),
            const SizedBox(height: 12),
            Text(
              label.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generarPdfConEtiquetas() async {
    final db = await DatabaseService.getDatabase();
    final items = await db.itemDao.obtenerItemsPorMudanza(widget.idMudanza);

    final etiquetas =
        items
            .map(
              (item) => {
                'mudanzaId': item.mudanzaId.toString(),
                'itemId': item.itemId.toString(),
                'itemName': item.nombre,
                'mudanzaName': mudanza?.nombre ?? '',
              },
            )
            .toList();

    await generarEtiquetasPdf(etiquetas);
  }



}
