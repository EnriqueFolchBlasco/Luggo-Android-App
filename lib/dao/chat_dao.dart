import 'package:floor/floor.dart';
import 'package:luggo/models/chat.dart';

@dao
abstract class ChatDao {
  @Query('SELECT * FROM Chat')
  Future<List<Chat>> obtenerTodos();

  @insert
  Future<void> insertar(Chat chat);

  @delete
  Future<void> eliminar(Chat chat);
}
