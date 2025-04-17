
import 'package:luggo/dao/item_dao.dart';
import 'package:luggo/models/item.dart';

class ItemRepositorio {
  final ItemDao dao;

  ItemRepositorio(this.dao);

  Future<List<Item>> obtenerTodos() => dao.obtenerTodos();
  Future<void> insertar(Item item) => dao.insertar(item);
  Future<void> eliminar(Item item) => dao.eliminar(item);
}
