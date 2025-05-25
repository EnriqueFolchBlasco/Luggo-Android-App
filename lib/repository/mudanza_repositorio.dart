import 'package:luggo/dao/mudanza_dao.dart';
import 'package:luggo/models/mudanza.dart';

class MudanzaRepositorio {
  final MudanzaDao dao;

  MudanzaRepositorio(this.dao);

  Future<List<Mudanza>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Mudanza mudanza) => dao.insertar(mudanza);
  Future<void> eliminar(Mudanza mudanza) => dao.eliminar(mudanza);
}
