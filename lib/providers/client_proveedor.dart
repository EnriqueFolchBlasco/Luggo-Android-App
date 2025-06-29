import 'package:flutter/material.dart';
import 'package:luggo/models/client.dart';
import 'package:luggo/repository/client_repositorio.dart';


class ClientProveedor with ChangeNotifier {
  final ClientRepositorio repositorio;

  List<Client> _lista = [];
  List<Client> get lista => _lista;

  ClientProveedor(this.repositorio);

  Future<void> cargarDatos() async {
    _lista = await repositorio.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregar(Client client) async {
    await repositorio.insertar(client);
    await cargarDatos();
  }

  Future<void> eliminar(Client client) async {
    await repositorio.eliminar(client);
    await cargarDatos();
  }
}
