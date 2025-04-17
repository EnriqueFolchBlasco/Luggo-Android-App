import 'package:luggo/dao/chat_dao.dart';
import 'package:luggo/models/chat.dart';

class ChatRepositorio {
  final ChatDao dao;

  ChatRepositorio(this.dao);

  Future<List<Chat>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Chat chat) => dao.insertar(chat);
  Future<void> eliminar(Chat chat) => dao.eliminar(chat);
}
