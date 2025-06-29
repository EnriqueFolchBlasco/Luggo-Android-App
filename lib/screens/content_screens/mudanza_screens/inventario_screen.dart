import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/item.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/item_detalles_screen.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/utils_widgets/modal_nueva_categoria.dart';
import 'package:luggo/utils/utils_widgets/modal_nuevo_item.dart';

class InventarioScreen extends StatefulWidget {
  final int idMudanza;

  const InventarioScreen({super.key, required this.idMudanza});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> with TickerProviderStateMixin {
  TabController? _controladorTabs;
  List<Map<String, dynamic>> categorias = [];
  bool cargando = true;
  int indexSeleccionat = 0;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  List<Tab> getTabs() {

    List<Tab> llistaCompleta = [];

    for (var x in categorias) {
      llistaCompleta.add(
        Tab(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // fallback per si no hi ha traduccio 
                Text(tr(x["nombre"])),
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
        ),
      );
    }

    llistaCompleta.add( //ANTI EFECTO per al plus
      Tab(
        child: GestureDetector(
          onTap: () {
            if (_controladorTabs != null) {
              _controladorTabs!.index = indexSeleccionat;
              _mostrarDialogoCrearCategoria();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: 
            Icon(Icons.add, color: AppColors.primaryColor),
          
        ),
      ),
    );

    return llistaCompleta;
  }


  Future<void> _cargarCategorias() async {
    try {
      final db = await DatabaseService.getDatabase();
      final mudanza = await db.mudanzaDao.obtenerPorId(widget.idMudanza);

      if (mudanza == null) return;

      final tabs = (mudanza.tabs ?? '')
              .split('|')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      final List<Map<String, dynamic>> llistaCategoriesTemproals = [];

      for (final tab in tabs) {
        final count = await db.itemDao.contarItemsPorCategoria(
          widget.idMudanza,
          tab,
        );

        final items = await db.itemDao.obtenerItemsPorCategoria(
          widget.idMudanza,
          tab,
        );

        llistaCategoriesTemproals.add({
          "nombre": tab,
          "cantidad": count,
          "items": items,
        });
      }

      setState(() {
        categorias = llistaCategoriesTemproals;

        _controladorTabs?.dispose();
        _controladorTabs = TabController(
          length: categorias.length + 1,
          vsync: this,
          initialIndex: indexSeleccionat < categorias.length + 1 ? indexSeleccionat : 0,
        );

        _controladorTabs!.addListener(() {
          final index = _controladorTabs!.index;

          if (!_controladorTabs!.indexIsChanging &&
              index == categorias.length) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controladorTabs!.animateTo(indexSeleccionat);
            });

            _mostrarDialogoCrearCategoria();
            return;
          }

          if (!_controladorTabs!.indexIsChanging && index < categorias.length) {
            indexSeleccionat = index;
          }
        });

        cargando = false;
      });
    } catch (e) {
      //print("Error en les categos");
    }
  }

  @override
  void dispose() {
    _controladorTabs?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
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
            final llistaCompleta = await Navigator.of(context).push(
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

            if (llistaCompleta == true) {
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
      body: Column(
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
              onPressed: () => Navigator.pop(context),
              splashRadius: 20,
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'miInventario'.tr(),
            style: const TextStyle(
              fontFamily: 'clashDisplay',
              color: AppColors.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 14),
          TabBar(
            controller: _controladorTabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            labelPadding: const EdgeInsets.only(right: 12),
            indicatorPadding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF0066FF), width: 1.3),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            tabs: getTabs(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [_crearFiltro("Estado"), _crearFiltro("Peso")],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _controladorTabs,
              physics: const ClampingScrollPhysics(),
              children: [
                ...categorias.map((i) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: i["items"].length,
                    itemBuilder: (context, index) {
                      final item = i["items"][index];
                      return _crearItem(item);
                    },
                  );
                }).toList(),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {

          final tabIndex = _controladorTabs?.index ?? indexSeleccionat;

          if (tabIndex < categorias.length) {
            final currentCategoria = categorias[tabIndex]["nombre"];
            _mostrarDialogoAgregarItem(currentCategoria);
          }


        },

      ),


    );  
  }

  Widget _crearFiltro(String texto) {
    return GestureDetector(
      onTap: () {
        //TO DO filtros
        print('filtro');
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
            
              
            const Icon(Icons.filter_alt_outlined, size: 16, color: Colors.black54 ),
            const SizedBox(width: 2),
            Text(
              texto,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            
            
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoAgregarItem(String categoriaInicial) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ModalNuevoItem(idMudanza: widget.idMudanza, categorias: categorias, categoriaActual: categoriaInicial,
          onItemGuardado: () async {
            await _cargarCategorias();
          },
        );
      },
    );
  } 

  void _mostrarDialogoCrearCategoria() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (context) {
        return ModalNuevaCategoria(idMudanza: widget.idMudanza,
          onCategoriaCreada: () async {
            await _cargarCategorias();
            setState(() {

              final indexNou = categorias.length - 1;
              indexSeleccionat = indexNou;
              _controladorTabs?.animateTo(indexNou);
              
            });
          },
        );
      },
    );
  }


  
  Widget _crearItem(Item item) {
    return GestureDetector(
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemDetallesScreen(
              itemId: item.itemId!,
              categorias: categorias.map((categoria) => categoria["nombre"] as String).toList(),
            ),
          ),
        );
        if (refresh == true) {
          await _cargarCategorias();
        }
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
            Icon(
              Icons.check_circle_outline,
              color: item.gotIt ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                item.nombre,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const Icon(Icons.chevron_right, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
