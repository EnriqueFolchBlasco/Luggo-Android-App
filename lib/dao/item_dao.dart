import 'package:floor/floor.dart';
import 'package:luggo/models/item.dart';

@dao
abstract class ItemDao {
  @Query('SELECT * FROM Item')
  Future<List<Item>> obtenerTodos();

  @insert
  Future<void> insertar(Item item);

  @Query('SELECT COUNT(*) FROM Item WHERE mudanzaId = :mudanzaId')
  Future<int?> contarItemsDeMudanza(int mudanzaId);

  @Query('SELECT nombre FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria')
  Future<List<String>> obtenerNombresDeItemsPorCategoria(int mudanzaId, String categoria);

  @Query('SELECT * FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria')
  Future<List<Item>> obtenerItemsPorCategoria(int mudanzaId, String categoria);


  @Query('SELECT COUNT(*) FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria')
  Future<int?> contarItemsPorCategoria(int mudanzaId, String categoria);

  @Query('SELECT EXISTS(SELECT 1 FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria LIMIT 1)')
  Future<bool?> existeItemConCategoria(int mudanzaId, String categoria);

  @Query('SELECT * FROM Item WHERE itemId = :id')
  Future<Item?> obtenerItemPorId(int id);

  @update
  Future<void> actualizarItem(Item item);

  @Query('DELETE FROM Item WHERE itemId = :id')
  Future<void> eliminarItemPorId(int id);

  @Query('SELECT * FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria AND nombre = :nombre LIMIT 1')
  Future<Item?> obtenerItemPorNombre(int mudanzaId, String categoria, String nombre);

  @Query('SELECT COUNT(*) FROM Item WHERE mudanzaId = :id AND gotIt = 1')
  Future<int?> contarItemsGotIt(int id);


}
