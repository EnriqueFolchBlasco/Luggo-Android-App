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
  final String notas;
  final String createdAt;
  final String? updatedAt;
  final bool isArchived;

  final String? tabs;

  Mudanza({
    this.mudanzaId,
    required this.userId,
    required this.fecha,
    required this.nombre,
    required this.direccionOrigen,
    required this.direccionDestino,
    required this.estado,
    required this.createdAt,
    required this.notas,
    this.updatedAt,
    this.isArchived = false,
    this.tabs,
  });

  List<String> get tabList =>
      (tabs == null || tabs!.isEmpty) ? [] : tabs!.split('|');

  Mudanza copyWithTabs(List<String> newTabs) => Mudanza(
    mudanzaId: mudanzaId,
    userId: userId,
    fecha: fecha,
    nombre: nombre,
    direccionOrigen: direccionOrigen,
    direccionDestino: direccionDestino,
    estado: estado,
    createdAt: createdAt,
    notas: notas,
    updatedAt: updatedAt,
    isArchived: isArchived,
    tabs: newTabs.join('|'),
  );
}
