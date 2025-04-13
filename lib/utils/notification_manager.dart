import 'package:flutter/foundation.dart';

class NotificationManager {
  static ValueNotifier<List<String>> notificaciones = ValueNotifier<List<String>>([]);

  static void agregar(String mensaje) {
    notificaciones.value = [mensaje, ...notificaciones.value];
  }

  static void eliminar(String mensaje) {
    notificaciones.value = List.from(notificaciones.value)..remove(mensaje);
  }

  static void limpiar() {
    notificaciones.value = [];
  }
}
