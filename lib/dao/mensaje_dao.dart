import 'package:floor/floor.dart';
import 'package:luggo/models/mensaje.dart';

@dao
abstract class MensajeDao {
  @Query('SELECT * FROM Mensaje')
  Future<List<Mensaje>> obtenerTodos();

  @insert
  Future<void> insertar(Mensaje mensaje);

  @delete
  Future<void> eliminar(Mensaje mensaje);
}
