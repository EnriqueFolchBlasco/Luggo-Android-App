import 'package:luggo/dao/client_dao.dart';
import 'package:luggo/models/client.dart';

class ClientRepositorio {
  final ClientDao dao;

  ClientRepositorio(this.dao);

  Future<List<Client>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Client client) => dao.insertar(client);
  Future<void> eliminar(Client client) => dao.eliminar(client);
}
