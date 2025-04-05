class NotificationManager {
  static List<String> notificaciones = [];

  static void agregar(String mensaje) {
    notificaciones.insert(0, mensaje);
  }

  static void eliminar(String mensaje) {
    notificaciones.remove(mensaje);
  }

  static void limpiar() {
    notificaciones.clear();
  }
}
