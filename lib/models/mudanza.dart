import 'package:floor/floor.dart';

@Entity(tableName: 'Mudanza')
class Mudanza {
  @PrimaryKey(autoGenerate: true)
  final int? mudanzaId;

  final String userId;
  final String fecha;
  final String nombre;
  final String direccionOrigen;
  final String direccionDestino;
  final String estado;

  Mudanza({
    this.mudanzaId,
    required this.nombre,
    required this.userId,
    required this.fecha,
    required this.direccionOrigen,
    required this.direccionDestino,
    required this.estado,
  });
}
