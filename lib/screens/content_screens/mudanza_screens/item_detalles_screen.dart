import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/models/item.dart';
import 'package:luggo/utils/utils_widgets/custom_form_widgets.dart';

class ItemDetallesScreen extends StatefulWidget {
  final int itemId;

  final List<String> categorias;

  const ItemDetallesScreen({
    super.key,
    required this.itemId,
    required this.categorias,
  });


  @override
  State<ItemDetallesScreen> createState() => _ItemDetallesScreenState();
}

class _ItemDetallesScreenState extends State<ItemDetallesScreen> {
  Item? item;
  bool loading = true;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();

  bool gotIt = false;
  String? estado;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _carregarItem();
  }

  Future<void> _carregarItem() async {
    final db = await DatabaseService.getDatabase();
    final loadedItem = await db.itemDao.obtenerItemPorId(widget.itemId);

    if (loadedItem != null) {
      setState(() {
        item = loadedItem;
        nombreController.text = loadedItem.nombre;
        descripcionController.text = loadedItem.descripcion ?? '';
        pesoController.text = loadedItem.peso?.toString() ?? '';
        categoriaController.text = loadedItem.categoria ?? '';
        fotoController.text = loadedItem.foto ?? '';
        gotIt = loadedItem.gotIt;
        estado = loadedItem.estado ?? 'Normal';
        if (loadedItem.foto != null && loadedItem.foto!.isNotEmpty) {
          selectedImage = File(loadedItem.foto!);
        }
        loading = false;
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (item == null){
      return;
    }

    final db = await DatabaseService.getDatabase();
    
    final updatedItem = Item(
      itemId: item!.itemId,
      mudanzaId: item!.mudanzaId,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      peso: double.tryParse(pesoController.text),
      gotIt: gotIt,
      categoria: categoriaController.text,
      estado: estado,
      foto: selectedImage?.path ?? fotoController.text,
    );

    await db.itemDao.actualizarItem(updatedItem);
    Navigator.pop(context, true);
  }

  Future<void> _eliminarItem() async {
    final db = await DatabaseService.getDatabase();
    await db.itemDao.eliminarItemPorId(widget.itemId);
    Navigator.pop(context, true);
  }

  Future<void> _elegirImatge() async {
    final picker = ImagePicker();
    final iamtgeDeGaleriaPicked = await picker.pickImage(source: ImageSource.gallery);
    if (iamtgeDeGaleriaPicked != null) {

      setState(() {
        selectedImage = File(iamtgeDeGaleriaPicked.path);
        fotoController.text = iamtgeDeGaleriaPicked.path;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          iconSize: 28,
          onPressed: () => Navigator.pop(context),
        ),
        title: Image(
          image: const AssetImage('assets/images/LuggoColor_noBackground.png'),
          height: 28,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 236, 52, 52)),
            onPressed: _eliminarItem,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                'detalleItem'.tr(),
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _elegirImatge,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                  image:
                      selectedImage != null
                          ? DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    selectedImage == null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_a_photo,
                                size: 36,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'addPhoto'.tr(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                        : null,
              ),
            ),

            const SizedBox(height: 24),
            LuggoLabel('enterName'.tr()),
            LuggoTextArea(
              controller: nombreController,
              hint: 'enterName'.tr(),
              maxLines: 1,
              keyboardType: TextInputType.text,
            ),

            LuggoLabel('descripcion'.tr()),
            LuggoTextArea(
              controller: descripcionController,
              hint: 'descripcion'.tr(),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
            LuggoLabel('peso'.tr()),
            LuggoTextArea(
              controller: pesoController,
              hint: 'peso'.tr(),
              maxLines: 1,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            LuggoLabel('tabs'.tr()),
            DropdownButtonFormField<String>(
              value:
                  widget.categorias.contains(categoriaController.text)
                      ? categoriaController.text
                      : null,
              onChanged: (value) {
                setState(() {
                  categoriaController.text = value!;
                });
              },
              items:
                  widget.categorias
                      .map(
                        (x) =>
                            DropdownMenuItem(value: x, child: Text(x.tr())))
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
            const SizedBox(height: 12),

            LuggoLabel('estado'.tr()),
            DropdownButtonFormField<String>(

              value: ['Normal','Frágil','Empaquetado','Urgente',].contains(estado) ? estado : 'Normal',

              onChanged: (value) => setState(() => estado = value),

              items:['Normal', 'Frágil', 'Empaquetado', 'Urgente'].map((e) => DropdownMenuItem(value: e, child: Text(e.tr()))).toList(),
                        
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(value: gotIt, onChanged: (v) => setState(() => gotIt = v!)),
                Text('gotIt'.tr()),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guardarCambios,
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        tooltip: 'guardar'.tr(),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}
