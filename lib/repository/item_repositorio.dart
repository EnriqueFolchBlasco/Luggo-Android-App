import 'package:luggo/dao/item_dao.dart';
import 'package:luggo/models/item.dart';

class ItemRepositorio {
  final ItemDao dao;

  ItemRepositorio(this.dao);

  Future<List<Item>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Item item) => dao.insertar(item);
  Future<void> eliminarPorId(int id) => dao.eliminarItemPorId(id);
  Future<void> actualizar(Item item) => dao.actualizarItem(item);
  Future<Item?> obtenerPorId(int id) => dao.obtenerItemPorId(id);
  Future<Item?> obtenerPorNombreYCategoria(int mudanzaId, String categoria, String nombre) =>
      dao.obtenerItemPorNombre(mudanzaId, categoria, nombre);
}
