import 'package:floor/floor.dart';

@Entity(tableName: 'Servicio')
class Servicio {
  @PrimaryKey(autoGenerate: true)
  final int? servicioId;

  final String userId;
  final String tipo;
  final String ubicacion;
  final String detallesTransporte;
  final double pago;

  Servicio(this.servicioId, this.userId, this.tipo, this.ubicacion, this.detallesTransporte, this.pago);
}
