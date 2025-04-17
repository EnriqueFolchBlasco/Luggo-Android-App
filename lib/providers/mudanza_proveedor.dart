import 'package:flutter/material.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:luggo/repository/mudanza_repositorio.dart';

class MudanzaProveedor with ChangeNotifier {
  final MudanzaRepositorio repositorio;

  List<Mudanza> _lista = [];
  List<Mudanza> get lista => _lista;

  MudanzaProveedor(this.repositorio);

  Future<void> cargarDatos() async {
    _lista = await repositorio.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregar(Mudanza mudanza) async {
    await repositorio.insertar(mudanza);
    await cargarDatos();
  }

  Future<void> eliminar(Mudanza mudanza) async {
    await repositorio.eliminar(mudanza);
    await cargarDatos();
  }
}
