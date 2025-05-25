import 'dart:async';
import 'package:floor/floor.dart';
import 'package:luggo/dao/chat_dao.dart';
import 'package:luggo/dao/client_dao.dart';
import 'package:luggo/dao/item_dao.dart';
import 'package:luggo/dao/mensaje_dao.dart';
import 'package:luggo/dao/mudanza_dao.dart';
import 'package:luggo/models/chat.dart';
import 'package:luggo/models/client.dart';
import 'package:luggo/models/item.dart';
import 'package:luggo/models/mensaje.dart';
import 'package:luggo/models/mudanza.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: 4,
  entities: [
    Mudanza,
    Item,
    Mensaje,
    Chat,
    Client,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  MudanzaDao get mudanzaDao;
  ItemDao get itemDao;
  MensajeDao get mensajeDao;
  ChatDao get chatDao;
  ClientDao get clientDao;
}
