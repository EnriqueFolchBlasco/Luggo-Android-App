import 'package:flutter/material.dart';
import 'package:luggo/utils/constants.dart';

class InventarioScreen extends StatefulWidget {
  final int idMudanza;

  const InventarioScreen({super.key, required this.idMudanza});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen>
    with TickerProviderStateMixin {
  late TabController _controladorTabs;

  // ***************************************************** */
  // HARDDDDDCODED DB IMPROTAR
  // ***************************************************** */
  final List<Map<String, dynamic>> categorias = [
    {
      "nombre": "Salón",
      "cantidad": 3,
      "items": ["Sofá", "TV", "Mesa"],
    },
    {
      "nombre": "Cocina",
      "cantidad": 2,
      "items": ["Sartén", "Horno"],
    },
    {
      "nombre": "Terraza",
      "cantidad": 1,
      "items": ["Planta"],
    },
    {
      "nombre": "Habitación",
      "cantidad": 2,
      "items": ["Cama", "Armario"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controladorTabs = TabController(length: categorias.length, vsync: this);
  }

  @override
  void dispose() {
    _controladorTabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 18),
          icon: const Icon(Icons.arrow_back),
          iconSize: 36,
          onPressed: () {
            Navigator.pop(context);
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
      body: Column(
        children: [
          const SizedBox(height: 8),

          TabBar(
            controller: _controladorTabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            labelPadding: const EdgeInsets.only(right: 12),
            indicatorPadding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,

            //**************************************************** */
            // estilo de pestraña
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF0066FF), width: 1.3),
            ),

            //**************************************************** */
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            tabs:
                categorias.map((x) {
                  return Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(x["nombre"]),
                          const SizedBox(width: 6),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: const Color(0xFF0066FF),
                            child: Text(
                              '${x["cantidad"]}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),

          // ***************************************************** */
          // TO DOOOOOOO
          // ***************************************************** */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [_crearFiltro("Estado"), _crearFiltro("Peso")],
            ),
          ),

          // ***************************************************** */
          // Llista items
          // ***************************************************** */
          Expanded(
            child: TabBarView(
              controller: _controladorTabs,
              children:
                  categorias.map((i) {
                    final items = List<String>.from(i["items"]);
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _crearItem(items[index]);
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),

      // ***************************************************** */
      // TO DOOOOOOO BOTO CREAR UN ITEM
      // ***************************************************** */
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Añadir ítem',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _crearFiltro(String texto) {
    return GestureDetector(
      onTap: () {
        print('filtro: $texto');
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.filter_alt_outlined,
              size: 16,
              color: Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              texto,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearItem(String nombreItem) {
    return GestureDetector(
      onTap: () {
        print('click: $nombreItem');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                nombreItem,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF0066FF),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
