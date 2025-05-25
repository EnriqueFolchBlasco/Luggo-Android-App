import 'package:floor/floor.dart';

@Entity(tableName: 'Item')
class Item {
  @PrimaryKey(autoGenerate: true)
  final int? itemId;
  final int mudanzaId;

  final String nombre;
  final double? peso;
  final String? foto;
  final String? descripcion;
  final bool gotIt;
  final String? categoria;
  final String? estado;

  Item({
    this.itemId,
    required this.mudanzaId,
    required this.nombre,
    this.peso,
    this.foto,
    this.descripcion,
    this.gotIt = false,
    this.categoria,
    this.estado,
  });

  Item copyWith({
    int? itemId,
    int? mudanzaId,
    String? nombre,
    String? categoria,
    double? peso,
    String? descripcion,
    bool? gotIt,
    String? foto,
    String? estado,
  }) {
    return Item(
      itemId: itemId ?? this.itemId,
      mudanzaId: mudanzaId ?? this.mudanzaId,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      peso: peso ?? this.peso,
      descripcion: descripcion ?? this.descripcion,
      gotIt: gotIt ?? this.gotIt,
      foto: foto ?? this.foto,
      estado: estado ?? this.estado,
    );
  }
}
