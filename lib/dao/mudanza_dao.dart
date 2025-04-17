import 'package:floor/floor.dart';
import '../models/mudanza.dart';

@dao
abstract class MudanzaDao {
  @Query('SELECT * FROM Mudanza')
  Future<List<Mudanza>> obtenerTodos();

  @insert
  Future<void> insertar(Mudanza mudanza);

  @delete
  Future<void> eliminar(Mudanza mudanza);

  @Query('SELECT * FROM Mudanza WHERE mudanzaId = :id')
  Future<Mudanza?> obtenerPorId(int id);
}
