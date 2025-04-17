import 'package:floor/floor.dart';

@Entity(tableName: 'Item')
class Item {
  @PrimaryKey(autoGenerate: true)
  final int? itemId;

  final int inventarioId;
  final String nombre;
  final double peso;
  final String? foto;
  final String? descripcion;

  Item({
    this.itemId,
    required this.inventarioId,
    required this.nombre,
    required this.peso,
    this.foto,
    this.descripcion,
  });
}
