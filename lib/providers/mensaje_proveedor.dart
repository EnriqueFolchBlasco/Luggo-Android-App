import 'package:flutter/foundation.dart';
import 'package:luggo/models/mensaje.dart';
import 'package:luggo/repository/mensaje_repositorio.dart';

class MensajeProveedor with ChangeNotifier {
  final MensajeRepositorio repositorio;

  List<Mensaje> _lista = [];
  List<Mensaje> get lista => _lista;

  MensajeProveedor(this.repositorio);

  Future<void> cargarDatos() async {
    _lista = await repositorio.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregar(Mensaje mensaje) async {
    await repositorio.insertar(mensaje);
    await cargarDatos();
  }

  Future<void> eliminar(Mensaje mensaje) async {
    await repositorio.eliminar(mensaje);
    await cargarDatos();
  }
}
