import 'package:floor/floor.dart';

@Entity(tableName: 'Inventario')
class Inventario {
  @PrimaryKey(autoGenerate: true)
  final int? inventarioId;

  final int mudanzaId;
  final String? categoria;

  Inventario({this.inventarioId, required this.mudanzaId, this.categoria});
}
