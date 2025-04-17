import 'package:flutter/material.dart';
import 'package:luggo/models/inventario.dart';
import 'package:luggo/repository/inventario_repositorio.dart';


class InventarioProveedor with ChangeNotifier {
  final InventarioRepositorio repositorio;

  List<Inventario> _lista = [];
  List<Inventario> get lista => _lista;

  InventarioProveedor(this.repositorio);

  Future<void> cargarDatos() async {
    _lista = await repositorio.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregar(Inventario inventario) async {
    await repositorio.insertar(inventario);
    await cargarDatos();
  }

  Future<void> eliminar(Inventario inventario) async {
    await repositorio.eliminar(inventario);
    await cargarDatos();
  }
}
