import 'package:floor/floor.dart';

@Entity(tableName: 'Mensaje')
class Mensaje {
  @PrimaryKey(autoGenerate: true)
  final int? mensajeId;

  final int chatId;
  final String remitente;
  final String contenido;
  final String timestamp;

  Mensaje(this.mensajeId, this.chatId, this.remitente, this.contenido, this.timestamp);
}
