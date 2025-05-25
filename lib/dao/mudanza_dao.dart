import 'package:floor/floor.dart';
import '../models/mudanza.dart';

@dao
abstract class MudanzaDao {
  @Query('SELECT * FROM Mudanza WHERE isArchived = 0')
  Future<List<Mudanza>> obtenerTodos();


  @Query('SELECT * FROM Mudanza')
  Future<List<Mudanza>> obtenerTodasConArchivadas();

  @insert
  Future<void> insertar(Mudanza mudanza);

  @delete
  Future<void> eliminar(Mudanza mudanza);

  @Query('SELECT * FROM Mudanza WHERE mudanzaId = :id')
  Future<Mudanza?> obtenerPorId(int id);

  @Query('DELETE FROM Mudanza WHERE mudanzaId = :id')
  Future<void> eliminarPorId(int id);

  @update
  Future<void> actualizar(Mudanza mudanza);

  @Query('UPDATE Mudanza SET tabs = :tabs WHERE mudanzaId = :id')
  Future<void> actualizarTabs(int id, String tabs);




}
