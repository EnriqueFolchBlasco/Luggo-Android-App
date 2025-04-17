import 'package:floor/floor.dart';

@Entity(tableName: 'Inventario')
class Inventario {
  @PrimaryKey(autoGenerate: true)
  final int? inventarioId;

  final int mudanzaId;

  Inventario({this.inventarioId, required this.mudanzaId});
}
