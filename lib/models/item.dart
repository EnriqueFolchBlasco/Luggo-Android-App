import 'package:floor/floor.dart';

@Entity(tableName: 'Item')
class Item {
  @PrimaryKey(autoGenerate: true)
  final int? itemId;
  final int mudanzaId;

  final int inventarioId;
  final String nombre;
  final double peso;
  final String? foto;
  final String? descripcion;
  final bool gotIt;
  final String? categoria;

  Item({
    this.itemId,
    required this.mudanzaId,
    required this.inventarioId,
    required this.nombre,
    required this.peso,
    this.foto,
    this.descripcion,
    this.gotIt = false,
    this.categoria,
  });
}
