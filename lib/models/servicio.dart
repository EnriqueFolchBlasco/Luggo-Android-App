import 'package:floor/floor.dart';

@Entity(tableName: 'Servicio')
class Servicio {
  @PrimaryKey(autoGenerate: true)
  final int? servicioId;

  final String userId;
  final String tipo;
  final String status;

  final String nombre;
  final String dni;
  final String telefono;
  final String email;

  final String ubicacion;
  final String destino;
  final String detallesTransporte;
  final String materiales;

  final String fecha;
  final String hora;

  final double pago;

  Servicio(
    this.servicioId,
    this.userId,
    this.tipo,
    this.status,
    this.nombre,
    this.dni,
    this.telefono,
    this.email,
    this.ubicacion,
    this.destino,
    this.detallesTransporte,
    this.materiales,
    this.fecha,
    this.hora,
    this.pago,
  );
}
