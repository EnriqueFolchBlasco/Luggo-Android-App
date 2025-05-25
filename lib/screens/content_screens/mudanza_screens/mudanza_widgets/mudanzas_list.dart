import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/crear_mudanza_screen.dart';
import 'package:luggo/screens/content_screens/mudanza_screens/menu_mudanza_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';


class MudanzasList extends StatefulWidget {
  const MudanzasList({super.key});

  @override
  State<MudanzasList> createState() => _MudanzasListState();
}

class _MudanzasListState extends State<MudanzasList> {
  List<Mudanza> mudanzas = [];
  bool cargando = true;
  Map<int, int> itemCounts = {};
  Map<int, int> gotItCounts = {};

  @override
  void initState() {
    super.initState();
    _cargarMudanzas();
  }

  Future<void> _cargarMudanzas() async {
    final db = await DatabaseService.getDatabase();
    final todas = await db.mudanzaDao.obtenerTodos();

    final counts = <int, int>{};
    final gotCounts = <int, int>{};

    for (final m in todas) {
      final total = await db.itemDao.contarItemsDeMudanza(m.mudanzaId!);
      final gotIt = await db.itemDao.contarItemsGotIt(m.mudanzaId!);

      counts[m.mudanzaId!] = total ?? 0;
      gotCounts[m.mudanzaId!] = gotIt ?? 0;
    }

    setState(() {
      mudanzas = todas;
      itemCounts = counts;
      gotItCounts = gotCounts;
      cargando = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: mudanzas.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index < mudanzas.length) {

                    final mudanza = mudanzas[index];

                    //Calcul del percentage
                    final count = itemCounts[mudanza.mudanzaId] ?? 0;
                    final got = gotItCounts[mudanza.mudanzaId] ?? 0;
                    final progress = count == 0 ? 0.0 : got / count;

                    return _mudanzaCard(context, mudanza, count, progress);

                  } else {

                    return _mudanzaCardAnadir(context);
                  }
                },
            ),
    );
  }

  Widget _mudanzaCard(BuildContext context, Mudanza mudanza, int itemCount, double progress) {
    String itemsCantidad = '${itemCounts[mudanza.mudanzaId] ?? 0} ${'items'.tr()}';

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MenuMudanzaScreen(idMudanza: mudanza.mudanzaId!),
          ),
        );

        if (result == true && mounted) {
          await _cargarMudanzas();
        }

      },

      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Text(
                'mudanza'.tr() + mudanza.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),


            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                mudanza.imatge,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(
                    itemsCantidad,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'progressLabel'.tr(),
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.blue,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mudanzaCardAnadir(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CrearMudanzaScreen()),
        );

        if (result == true && mounted) {
          setState(() {
            cargando = true;
          });
          await _cargarMudanzas();
        }

      },
      
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha((0.08 * 255).round()),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Icon(
            Icons.add_outlined,
            size: 50,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
