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


}
