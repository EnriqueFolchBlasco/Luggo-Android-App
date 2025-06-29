import 'package:flutter/material.dart';
import 'package:luggo/models/item.dart';
import 'package:luggo/repository/item_repositorio.dart';

class ItemProveedor with ChangeNotifier {
  final ItemRepositorio repositorio;

  List<Item> _lista = [];
  List<Item> get lista => _lista;

  ItemProveedor(this.repositorio);

  Future<void> cargarDatos() async {
    _lista = await repositorio.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregar(Item item) async {
    await repositorio.insertar(item);
    await cargarDatos();
  }

  Future<void> eliminarPorId(int id) async {
    await repositorio.eliminarPorId(id);
    await cargarDatos();
  }

  Future<void> actualizar(Item item) async {
    await repositorio.actualizar(item);
    await cargarDatos();
  }

  Future<Item?> obtenerPorId(int id) async {
    return await repositorio.obtenerPorId(id);
  }
}
