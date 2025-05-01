import 'package:floor/floor.dart';
import 'package:luggo/models/item.dart';

@dao
abstract class ItemDao {
  @Query('SELECT * FROM Item')
  Future<List<Item>> obtenerTodos();

  @insert
  Future<void> insertar(Item item);

  @delete
  Future<void> eliminar(Item item);

  @Query('SELECT * FROM Item WHERE inventarioId = :inventarioId')
  Future<List<Item>> obtenerPorInventario(int inventarioId);

  @Query('SELECT COUNT(*) FROM Inventario WHERE mudanzaId = :mudanzaId')
  Future<int?> contarItemsDeMudanza(int mudanzaId);


}
