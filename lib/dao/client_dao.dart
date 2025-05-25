import 'package:floor/floor.dart';
import 'package:luggo/models/client.dart';

@dao
abstract class ClientDao {
  @Query('SELECT * FROM Client')
  Future<List<Client>> obtenerTodos();

  @insert
  Future<void> insertar(Client client);

  @delete
  Future<void> eliminar(Client client);
}
