import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/screens/sideBar_screens/sidebar_screen.dart';
import 'package:luggo/services/database_service.dart';
import 'package:luggo/utils/constants.dart';

class NotasMudanzaScreen extends StatefulWidget {
  final int mudanzaId;

  const NotasMudanzaScreen({required this.mudanzaId, super.key});

  @override
  State<NotasMudanzaScreen> createState() => _NotasMudanzaScreenState();
}

class _NotasMudanzaScreenState extends State<NotasMudanzaScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  late Mudanza _mudanza;
  Timer? _guardadoAutomatico;

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  Future<void> _carregarNotas() async {
    final db = await DatabaseService.getDatabase();
    final mudanza = await db.mudanzaDao.obtenerPorId(widget.mudanzaId);

    if (mudanza != null) {
      _mudanza = mudanza;
      _controller.text = mudanza.notas;
      _controller.addListener(_notaACambiado);
    }
    setState(() => _loading = false);
  }

  void _notaACambiado() {
    if (_guardadoAutomatico?.isActive ?? false) _guardadoAutomatico!.cancel();

    _guardadoAutomatico = Timer(const Duration(seconds: 1), () async {
      final db = await DatabaseService.getDatabase();

      final ultimsTabs = (await db.mudanzaDao.obtenerPorId(_mudanza.mudanzaId!))?.tabs ?? '';

      await db.mudanzaDao.actualizar(
        _mudanza.copyWith(
          notas: _controller.text,
          updatedAt: DateTime.now().toIso8601String(),
          tabs: ultimsTabs,
        ),
      );

      _mudanza = _mudanza.copyWith(
        notas: _controller.text,
        updatedAt: DateTime.now().toIso8601String(),
        tabs: ultimsTabs,
      );
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
            // ***************************************************** */
            // MENU DE LATERAL
            // ***************************************************** */

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

            // Condicio per a fer qe al cambiar idioma se cambie la bottombar en altres labels
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
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                          Navigator.pop(context);
                        },
                        splashRadius: 20,
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'misNotas'.tr(),
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
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox.expand(
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontFamily: 'clashDisplay',
                                fontSize: 14,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'notasTexto'.tr(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),

                  ],
                ),
              ),
    );
  }
}
