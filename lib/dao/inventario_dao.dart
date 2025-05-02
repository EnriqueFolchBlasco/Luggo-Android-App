import 'package:floor/floor.dart';
import '../models/inventario.dart';

@dao
abstract class InventarioDao {
  @Query('SELECT * FROM Inventario')
  Future<List<Inventario>> obtenerTodos();

  @insert
  Future<void> insertar(Inventario inventario);

  @delete
  Future<void> eliminar(Inventario inventario);

  @Query('SELECT * FROM Inventario WHERE mudanzaId = :mudanzaId')
  Future<Inventario?> obtenerPorMudanza(int mudanzaId);

  @Query('SELECT COUNT(*) FROM Inventario WHERE mudanzaId = :mudanzaId')
  Future<int?> contarItemsDeMudanza(int mudanzaId);

  @Query('SELECT COUNT(*) FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria')
  Future<int?> contarItemsPorCategoria(int mudanzaId, String categoria);

  @Query('SELECT EXISTS(SELECT 1 FROM inventario WHERE mudanzaId = :mudanzaId AND categoria = :categoria LIMIT 1)')
  Future<bool?> existeItemConCategoria(int mudanzaId, String categoria);


}
