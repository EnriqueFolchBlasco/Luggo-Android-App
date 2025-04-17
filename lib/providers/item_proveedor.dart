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

  Future<void> eliminar(Item item) async {
    await repositorio.eliminar(item);
    await cargarDatos();
  }
}
