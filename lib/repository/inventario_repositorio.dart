import 'package:luggo/dao/inventario_dao.dart';
import 'package:luggo/models/inventario.dart';

class InventarioRepositorio {
  final InventarioDao dao;

  InventarioRepositorio(this.dao);

  Future<List<Inventario>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Inventario inventario) => dao.insertar(inventario);
  Future<void> eliminar(Inventario inventario) => dao.eliminar(inventario);
}
