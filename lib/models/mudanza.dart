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

  final String createdAt;
  final String? updatedAt;
  final bool isArchived;

  Mudanza({
    this.mudanzaId,
    required this.userId,
    required this.fecha,
    required this.nombre,
    required this.direccionOrigen,
    required this.direccionDestino,
    required this.estado,
    required this.createdAt,
    this.updatedAt,
    this.isArchived = false,
  });
}
