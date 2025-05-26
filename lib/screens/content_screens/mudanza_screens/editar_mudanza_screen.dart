import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/custom_form_widgets.dart';

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
  final TextEditingController _controlladorCategoriaNova = TextEditingController();

  List<String> _categories = [];
  final List<String> _imageOptions = [ 'assets/images/Luggo_Baseline Color 1_2.png', 'assets/images/mudanza_background1.png', 'assets/images/mudanza_background2.png', 'assets/images/Luggo_Baseline Color.png'];

  String _estado = 'Planificada';
  int _itemsCount = 0;

  Timer? _seHaActualizado;
  bool _antiNoCarregat = false;
  late Mudanza mudanza;

  @override
  void initState() {
    super.initState();
    _loadMudanzaActualizada();
  }

  Future<void> _loadMudanzaActualizada() async {

    final db = await DatabaseService.getDatabase();

    final refreshed = await db.mudanzaDao.obtenerPorId(
      widget.mudanza.mudanzaId!,
    );

    mudanza = refreshed!;
    


    _nombreCtrl = TextEditingController(text: refreshed!.nombre);
    _origenCtrl = TextEditingController(text: refreshed.direccionOrigen);
    _destinoCtrl = TextEditingController(text: refreshed.direccionDestino);
    _estado = refreshed.estado;

    _categories =
        (refreshed.tabs ?? '')
            .split('|')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();


    _nombreCtrl.addListener(_autoGuardado);
    _origenCtrl.addListener(_autoGuardado);
    _destinoCtrl.addListener(_autoGuardado);

    await _cantidadItems();

    setState(() {
      _antiNoCarregat = true;
    });
  }

  Future<void> _cantidadItems() async {
    final db = await DatabaseService.getDatabase();
    final count = await db.itemDao.contarItemsDeMudanza(widget.mudanza.mudanzaId!);

    setState(() {
      _itemsCount = count!;
    });
  }

  void _autoGuardado() {
    _seHaActualizado?.cancel();
    _seHaActualizado = Timer(const Duration(seconds: 1), _guardarEstadoActual);
  }

  Future<void> _guardarEstadoActual() async {
    final db = await DatabaseService.getDatabase();

    final latestTabs = (await db.mudanzaDao.obtenerPorId(mudanza.mudanzaId!))?.tabs ?? '';

    final joinedTabs = _categories.where((e) => e.trim().isNotEmpty).join('|');

    final tabsFinal = joinedTabs.isEmpty ? latestTabs : joinedTabs;

    final updated = mudanza.copyWith(
      nombre: _nombreCtrl.text.trim(),
      direccionOrigen: _origenCtrl.text.trim(),
      direccionDestino: _destinoCtrl.text.trim(),
      estado: _estado,
      tabs: tabsFinal,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await db.mudanzaDao.actualizar(updated);
  }


  @override
  void dispose() {

    _seHaActualizado?.cancel();
    _nombreCtrl.dispose();
    _origenCtrl.dispose();
    _destinoCtrl.dispose();
    _controlladorCategoriaNova.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_antiNoCarregat) { //antipetada gastronomica
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

            if (result == true) {
              setState(() {});
            }
          },
        ),
        title: 
           
            Image(
              image: AssetImage('assets/images/LuggoColor_noBackground.png'),
              height: 28,
            ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Navigator.pop(context, true);
                      },
                      splashRadius: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'editMode'.tr(),
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
              items:
                  ['Planificada', 'En curso', 'Completada']
                      .map(
                        (estado) => DropdownMenuItem(
                          value: estado,
                          child: Text(estado.tr()),
                        ),
                      )
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
              children:
                  _categories.map((tab) {
                    return Chip(
                      label: Text(tab.tr()),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () async {
                        final db = await DatabaseService.getDatabase();
                        final isUsed = await db.itemDao.existeItemConCategoria(widget.mudanza.mudanzaId!, tab);


                        if (isUsed == true) {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text('warning'.tr()),
                                  content: Text(
                                    'cannotDeleteCategoryInUse'.tr(),
                                  ),
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
                          _categories.remove(tab);
                        });
                        await _guardarEstadoActual();
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controlladorCategoriaNova,
                    decoration: InputDecoration(
                      hintText: 'addNewTab'.tr(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                  onPressed: () async {
                    final newTab = _controlladorCategoriaNova.text.trim();

                    final esValit = newTab.isNotEmpty && !newTab.contains('|');

                    if (esValit && !_categories.contains(newTab)) {

                      setState(() {
                        _categories.add(newTab);
                        _controlladorCategoriaNova.clear();
                      });
                      await _guardarEstadoActual();
                      _autoGuardado();
                    }
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 24),
            LuggoLabel('chooseBackground'.tr()),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _imageOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final imagePath = _imageOptions[index];
                  final isSelected = mudanza.imatge == imagePath;

                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        mudanza = mudanza.copyWith(imatge: imagePath);
                      });

                      await _guardarEstadoActual();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imagePath,
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${'items'.tr()}: $_itemsCount',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "clashDisplay",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${'created'.tr()}: ${widget.mudanza.createdAt.split("T").first}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "clashDisplay",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.update, color: AppColors.primaryColor, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${'updated'.tr()}: ${widget.mudanza.updatedAt?.split("T").first ?? "-"}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "clashDisplay",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),

          ],
        ),
      ),
    );
  }
}
