import 'package:luggo/dao/mensaje_dao.dart';
import 'package:luggo/models/mensaje.dart';

class MensajeRepositorio {
  final MensajeDao dao;

  MensajeRepositorio(this.dao);

  Future<List<Mensaje>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Mensaje mensaje) => dao.insertar(mensaje);
  Future<void> eliminar(Mensaje mensaje) => dao.eliminar(mensaje);
}
