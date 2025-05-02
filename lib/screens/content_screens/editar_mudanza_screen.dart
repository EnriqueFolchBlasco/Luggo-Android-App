
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
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
  final TextEditingController _newTabController = TextEditingController();
  List<String> _tabs = [];
  String _estado = 'Planificada';
  int _itemsCount = 0;
  Timer? _seHaActualizado;

  @override
  void initState() {
    super.initState();
    _loadMudanzaActualizada();
  }

  Future<void> _loadMudanzaActualizada() async {
    final db = await DatabaseService.getDatabase();
    final refreshed = await db.mudanzaDao.obtenerPorId(widget.mudanza.mudanzaId!);

    setState(() {
      _nombreCtrl = TextEditingController(text: refreshed!.nombre);
      _origenCtrl = TextEditingController(text: refreshed.direccionOrigen);
      _destinoCtrl = TextEditingController(text: refreshed.direccionDestino);
      _estado = refreshed.estado;
      _tabs = refreshed.tabs?.split('|') ?? [];
    });

    _nombreCtrl.addListener(_autoGuardado);
    _origenCtrl.addListener(_autoGuardado);
    _destinoCtrl.addListener(_autoGuardado);
    _cantidadItems();
  }

  Future<void> _cantidadItems() async {
    final db = await DatabaseService.getDatabase();
    final count = await db.inventarioDao.contarItemsDeMudanza(
      widget.mudanza.mudanzaId!,
    );
    setState(() {
      _itemsCount = count!;
    });
  }

  void _autoGuardado() {
    _seHaActualizado?.cancel();
    _seHaActualizado = Timer(const Duration(seconds: 1), () async {
      final db = await DatabaseService.getDatabase();
      final updated = Mudanza(
        mudanzaId: widget.mudanza.mudanzaId,
        userId: widget.mudanza.userId,
        nombre: _nombreCtrl.text.trim(),
        fecha: widget.mudanza.fecha,
        direccionOrigen: _origenCtrl.text.trim(),
        direccionDestino: _destinoCtrl.text.trim(),
        estado: _estado,
        notas: widget.mudanza.notas,
        createdAt: widget.mudanza.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        isArchived: widget.mudanza.isArchived,
        tabs: _tabs.join('|'),
      );
      await db.mudanzaDao.actualizar(updated);
    });
  }

  @override
  void dispose() {
    _seHaActualizado?.cancel();
    _nombreCtrl.dispose();
    _origenCtrl.dispose();
    _destinoCtrl.dispose();
    _newTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.isEmpty && _nombreCtrl.text.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
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
            if (result == true) {
              setState(() {});
            }
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Column(
              children: [
                Center(
                  child: Container(
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
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Modo edición'.tr(),
                    style: const TextStyle(
                      fontFamily: 'clashDisplay',
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            LuggoLabel('moveName'.tr()),
            LuggoTextField(controller: _nombreCtrl, hint: 'enterMoveName'.tr()),

            LuggoLabel('originAddress'.tr()),
            LuggoTextField(controller: _origenCtrl, hint: 'enterOrigin'.tr()),

            LuggoLabel('destinationAddress'.tr()),
            LuggoTextField(
              controller: _destinoCtrl,
              hint: 'enterDestination'.tr(),
            ),

            LuggoLabel('estado'.tr()),
            DropdownButtonFormField<String>(
              value: _estado,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _estado = value);
                  _autoGuardado();
                }
              },
              items: ['Planificada', 'En curso', 'Completada']
                  .map((estado) => DropdownMenuItem(
                        value: estado,
                        child: Text(estado.tr()),
                      ))
                  .toList(),
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

            const SizedBox(height: 24),
            LuggoLabel('tabs'.tr()),
            Wrap(
  spacing: 8,
  children: _tabs.map((tab) {
    return Chip(
      label: Text(tab),
      deleteIcon: const Icon(Icons.close),
      onDeleted: () async {
        final db = await DatabaseService.getDatabase();

        if (_tabs.length <= 1) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('warning'.tr()),
              content: Text('atLeastOneCategoryMustExist'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ok'.tr()),
                ),
              ],
            ),
          );
          return;
        }

        final isUsed = await db.inventarioDao.existeItemConCategoria(
          widget.mudanza.mudanzaId!,
          tab,
        );

        if (isUsed == true) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('warning'.tr()),
              content: Text('cannotDeleteCategoryInUse'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ok'.tr()),
                ),
              ],
            ),
          );
          return;
        }

        setState(() {
          _tabs.remove(tab);
        });
        _autoGuardado();
      },
    );
  }).toList(),
),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTabController,
                    decoration: InputDecoration(
                      hintText: 'addNewTab'.tr(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(34),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    final newTab = _newTabController.text.trim();
                    if (newTab.isNotEmpty && !_tabs.contains(newTab)) {
                      setState(() {
                        _tabs.add(newTab);
                        _newTabController.clear();
                      });
                      _autoGuardado();
                    }
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.black54,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${'items'.tr()}: $_itemsCount',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black38,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${'created'.tr()}: ${widget.mudanza.createdAt.split("T").first}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.update, color: Colors.black38, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${'updated'.tr()}: ${widget.mudanza.updatedAt?.split("T").first ?? "-"}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
