import 'package:floor/floor.dart';
import 'package:luggo/models/item.dart';

@dao
abstract class ItemDao {
  @Query('SELECT * FROM Item')
  Future<List<Item>> obtenerTodos();

  @insert
  Future<void> insertar(Item item);

  @insert
  Future<void> insertarItem(Item item);

  @delete
  Future<void> eliminar(Item item);

  @Query('SELECT COUNT(*) FROM Item WHERE mudanzaId = :mudanzaId')
  Future<int?> contarItemsDeMudanza(int mudanzaId);
  
  @Query('SELECT nombre FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria')
  Future<List<String>> obtenerNombresDeItemsPorCategoria(int mudanzaId, String categoria);

  @Query('SELECT COUNT(*) FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria')
  Future<int?> contarItemsPorCategoria(int mudanzaId, String categoria);

  @Query('SELECT EXISTS(SELECT 1 FROM Item WHERE mudanzaId = :mudanzaId AND categoria = :categoria LIMIT 1)')
  Future<bool?> existeItemConCategoria(int mudanzaId, String categoria);


}
