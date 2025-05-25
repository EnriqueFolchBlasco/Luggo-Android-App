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
  final String imatge;

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
    required this.imatge,
    this.updatedAt,
    this.isArchived = false,
    this.tabs,
  });


  //Logica gestionar Tabs/categories

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
    imatge: imatge, 
  );



  Mudanza copyWith({
    int? mudanzaId,
    String? userId,
    String? fecha,
    String? nombre,
    String? direccionOrigen,
    String? direccionDestino,
    String? estado,
    String? notas,
    String? createdAt,
    String? updatedAt,
    bool? isArchived,
    String? imatge,
    String? tabs,
  }) {
    return Mudanza(
      mudanzaId: mudanzaId ?? this.mudanzaId,
      userId: userId ?? this.userId,
      fecha: fecha ?? this.fecha,
      nombre: nombre ?? this.nombre,
      direccionOrigen: direccionOrigen ?? this.direccionOrigen,
      direccionDestino: direccionDestino ?? this.direccionDestino,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      imatge: imatge ?? this.imatge,
      tabs: tabs ?? this.tabs,
    );
  }
}
