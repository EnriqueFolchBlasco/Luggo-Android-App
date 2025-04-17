import 'package:flutter/material.dart';
import 'package:luggo/models/chat.dart';
import 'package:luggo/repository/chat_repositorio.dart';

class ChatProveedor with ChangeNotifier {
  final ChatRepositorio repositorio;

  List<Chat> _lista = [];
  List<Chat> get lista => _lista;

  ChatProveedor(this.repositorio);

  Future<void> cargarDatos() async {
    _lista = await repositorio.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregar(Chat chat) async {
    await repositorio.insertar(chat);
    await cargarDatos();
  }

  Future<void> eliminar(Chat chat) async {
    await repositorio.eliminar(chat);
    await cargarDatos();
  }
}
