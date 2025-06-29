import 'package:flutter/material.dart';
import 'package:luggo/utils/constants.dart';
import 'package:luggo/utils/notification_manager.dart';

class NotificacionesOverlay extends StatelessWidget {
  final Offset posicio;
  final VoidCallback tancarOverlay;
  final VoidCallback refrescarUI;

  const NotificacionesOverlay({super.key, required this.posicio, required this.tancarOverlay, required this.refrescarUI});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: tancarOverlay,
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: posicio.dy + 45,
          right: 16,
          child: AnimatedSlide(
            offset: const Offset(0, -0.03),
            duration: const Duration(milliseconds: 200),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 300,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: NotificationManager.notificaciones.value.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "N/A",
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'clashDisplay',
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: NotificationManager.notificaciones.value
                                .map(
                                  (texto) => Column(
                                    children: [
                                      _NotificacionItem(
                                        texto: texto,
                                        tancarOverlay: tancarOverlay,
                                        refrescarUI: refrescarUI,
                                      ),
                                      const Divider(height: 14, thickness: 0.6),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//items de clase + construccio
class _NotificacionItem extends StatelessWidget {
  final String texto;
  final VoidCallback tancarOverlay;
  final VoidCallback refrescarUI;

  const _NotificacionItem({required this.texto, required this.tancarOverlay, required this.refrescarUI});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NotificationManager.eliminar(texto);
        tancarOverlay();
        refrescarUI();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_none, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'clashDisplay',
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
