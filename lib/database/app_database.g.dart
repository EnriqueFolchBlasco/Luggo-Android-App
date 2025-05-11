// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MudanzaDao? _mudanzaDaoInstance;

  ItemDao? _itemDaoInstance;

  MensajeDao? _mensajeDaoInstance;

  ChatDao? _chatDaoInstance;

  ClientDao? _clientDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 4,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Mudanza` (`mudanzaId` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` TEXT NOT NULL, `fecha` TEXT NOT NULL, `nombre` TEXT NOT NULL, `direccionOrigen` TEXT NOT NULL, `direccionDestino` TEXT NOT NULL, `estado` TEXT NOT NULL, `notas` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `updatedAt` TEXT, `isArchived` INTEGER NOT NULL, `imatge` TEXT NOT NULL, `tabs` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Item` (`itemId` INTEGER PRIMARY KEY AUTOINCREMENT, `mudanzaId` INTEGER NOT NULL, `nombre` TEXT NOT NULL, `peso` REAL, `foto` TEXT, `descripcion` TEXT, `gotIt` INTEGER NOT NULL, `categoria` TEXT, `estado` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Mensaje` (`mensajeId` INTEGER PRIMARY KEY AUTOINCREMENT, `chatId` INTEGER NOT NULL, `remitente` TEXT NOT NULL, `contenido` TEXT NOT NULL, `timestamp` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Chat` (`chatId` INTEGER PRIMARY KEY AUTOINCREMENT, `user1` TEXT NOT NULL, `user2` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Client` (`userId` TEXT NOT NULL, `user` TEXT NOT NULL, `profilePhoto` TEXT, PRIMARY KEY (`userId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MudanzaDao get mudanzaDao {
    return _mudanzaDaoInstance ??= _$MudanzaDao(database, changeListener);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }

  @override
  MensajeDao get mensajeDao {
    return _mensajeDaoInstance ??= _$MensajeDao(database, changeListener);
  }

  @override
  ChatDao get chatDao {
    return _chatDaoInstance ??= _$ChatDao(database, changeListener);
  }

  @override
  ClientDao get clientDao {
    return _clientDaoInstance ??= _$ClientDao(database, changeListener);
  }
}

class _$MudanzaDao extends MudanzaDao {
  _$MudanzaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _mudanzaInsertionAdapter = InsertionAdapter(
            database,
            'Mudanza',
            (Mudanza item) => <String, Object?>{
                  'mudanzaId': item.mudanzaId,
                  'userId': item.userId,
                  'fecha': item.fecha,
                  'nombre': item.nombre,
                  'direccionOrigen': item.direccionOrigen,
                  'direccionDestino': item.direccionDestino,
                  'estado': item.estado,
                  'notas': item.notas,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'isArchived': item.isArchived ? 1 : 0,
                  'imatge': item.imatge,
                  'tabs': item.tabs
                }),
        _mudanzaUpdateAdapter = UpdateAdapter(
            database,
            'Mudanza',
            ['mudanzaId'],
            (Mudanza item) => <String, Object?>{
                  'mudanzaId': item.mudanzaId,
                  'userId': item.userId,
                  'fecha': item.fecha,
                  'nombre': item.nombre,
                  'direccionOrigen': item.direccionOrigen,
                  'direccionDestino': item.direccionDestino,
                  'estado': item.estado,
                  'notas': item.notas,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'isArchived': item.isArchived ? 1 : 0,
                  'imatge': item.imatge,
                  'tabs': item.tabs
                }),
        _mudanzaDeletionAdapter = DeletionAdapter(
            database,
            'Mudanza',
            ['mudanzaId'],
            (Mudanza item) => <String, Object?>{
                  'mudanzaId': item.mudanzaId,
                  'userId': item.userId,
                  'fecha': item.fecha,
                  'nombre': item.nombre,
                  'direccionOrigen': item.direccionOrigen,
                  'direccionDestino': item.direccionDestino,
                  'estado': item.estado,
                  'notas': item.notas,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'isArchived': item.isArchived ? 1 : 0,
                  'imatge': item.imatge,
                  'tabs': item.tabs
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Mudanza> _mudanzaInsertionAdapter;

  final UpdateAdapter<Mudanza> _mudanzaUpdateAdapter;

  final DeletionAdapter<Mudanza> _mudanzaDeletionAdapter;

  @override
  Future<List<Mudanza>> obtenerTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Mudanza WHERE isArchived = 0',
        mapper: (Map<String, Object?> row) => Mudanza(
            mudanzaId: row['mudanzaId'] as int?,
            userId: row['userId'] as String,
            fecha: row['fecha'] as String,
            nombre: row['nombre'] as String,
            direccionOrigen: row['direccionOrigen'] as String,
            direccionDestino: row['direccionDestino'] as String,
            estado: row['estado'] as String,
            createdAt: row['createdAt'] as String,
            notas: row['notas'] as String,
            imatge: row['imatge'] as String,
            updatedAt: row['updatedAt'] as String?,
            isArchived: (row['isArchived'] as int) != 0,
            tabs: row['tabs'] as String?));
  }

  @override
  Future<List<Mudanza>> obtenerTodasConArchivadas() async {
    return _queryAdapter.queryList('SELECT * FROM Mudanza',
        mapper: (Map<String, Object?> row) => Mudanza(
            mudanzaId: row['mudanzaId'] as int?,
            userId: row['userId'] as String,
            fecha: row['fecha'] as String,
            nombre: row['nombre'] as String,
            direccionOrigen: row['direccionOrigen'] as String,
            direccionDestino: row['direccionDestino'] as String,
            estado: row['estado'] as String,
            createdAt: row['createdAt'] as String,
            notas: row['notas'] as String,
            imatge: row['imatge'] as String,
            updatedAt: row['updatedAt'] as String?,
            isArchived: (row['isArchived'] as int) != 0,
            tabs: row['tabs'] as String?));
  }

  @override
  Future<Mudanza?> obtenerPorId(int id) async {
    return _queryAdapter.query('SELECT * FROM Mudanza WHERE mudanzaId = ?1',
        mapper: (Map<String, Object?> row) => Mudanza(
            mudanzaId: row['mudanzaId'] as int?,
            userId: row['userId'] as String,
            fecha: row['fecha'] as String,
            nombre: row['nombre'] as String,
            direccionOrigen: row['direccionOrigen'] as String,
            direccionDestino: row['direccionDestino'] as String,
            estado: row['estado'] as String,
            createdAt: row['createdAt'] as String,
            notas: row['notas'] as String,
            imatge: row['imatge'] as String,
            updatedAt: row['updatedAt'] as String?,
            isArchived: (row['isArchived'] as int) != 0,
            tabs: row['tabs'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> eliminarPorId(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Mudanza WHERE mudanzaId = ?1',
        arguments: [id]);
  }

  @override
  Future<void> actualizarTabs(
    int id,
    String tabs,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Mudanza SET tabs = ?2 WHERE mudanzaId = ?1',
        arguments: [id, tabs]);
  }

  @override
  Future<void> insertar(Mudanza mudanza) async {
    await _mudanzaInsertionAdapter.insert(mudanza, OnConflictStrategy.abort);
  }

  @override
  Future<void> actualizar(Mudanza mudanza) async {
    await _mudanzaUpdateAdapter.update(mudanza, OnConflictStrategy.abort);
  }

  @override
  Future<void> eliminar(Mudanza mudanza) async {
    await _mudanzaDeletionAdapter.delete(mudanza);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'Item',
            (Item item) => <String, Object?>{
                  'itemId': item.itemId,
                  'mudanzaId': item.mudanzaId,
                  'nombre': item.nombre,
                  'peso': item.peso,
                  'foto': item.foto,
                  'descripcion': item.descripcion,
                  'gotIt': item.gotIt ? 1 : 0,
                  'categoria': item.categoria,
                  'estado': item.estado
                }),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'Item',
            ['itemId'],
            (Item item) => <String, Object?>{
                  'itemId': item.itemId,
                  'mudanzaId': item.mudanzaId,
                  'nombre': item.nombre,
                  'peso': item.peso,
                  'foto': item.foto,
                  'descripcion': item.descripcion,
                  'gotIt': item.gotIt ? 1 : 0,
                  'categoria': item.categoria,
                  'estado': item.estado
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  @override
  Future<List<Item>> obtenerTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Item',
        mapper: (Map<String, Object?> row) => Item(
            itemId: row['itemId'] as int?,
            mudanzaId: row['mudanzaId'] as int,
            nombre: row['nombre'] as String,
            peso: row['peso'] as double?,
            foto: row['foto'] as String?,
            descripcion: row['descripcion'] as String?,
            gotIt: (row['gotIt'] as int) != 0,
            categoria: row['categoria'] as String?,
            estado: row['estado'] as String?));
  }

  @override
  Future<List<Item>> obtenerItemsPorMudanza(int mudanzaId) async {
    return _queryAdapter.queryList('SELECT * FROM Item WHERE mudanzaId = ?1',
        mapper: (Map<String, Object?> row) => Item(
            itemId: row['itemId'] as int?,
            mudanzaId: row['mudanzaId'] as int,
            nombre: row['nombre'] as String,
            peso: row['peso'] as double?,
            foto: row['foto'] as String?,
            descripcion: row['descripcion'] as String?,
            gotIt: (row['gotIt'] as int) != 0,
            categoria: row['categoria'] as String?,
            estado: row['estado'] as String?),
        arguments: [mudanzaId]);
  }

  @override
  Future<List<Item>> obtenerItemsPorCategoria(
    int mudanzaId,
    String categoria,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Item WHERE mudanzaId = ?1 AND categoria = ?2',
        mapper: (Map<String, Object?> row) => Item(
            itemId: row['itemId'] as int?,
            mudanzaId: row['mudanzaId'] as int,
            nombre: row['nombre'] as String,
            peso: row['peso'] as double?,
            foto: row['foto'] as String?,
            descripcion: row['descripcion'] as String?,
            gotIt: (row['gotIt'] as int) != 0,
            categoria: row['categoria'] as String?,
            estado: row['estado'] as String?),
        arguments: [mudanzaId, categoria]);
  }

  @override
  Future<List<String>> obtenerNombresDeItemsPorCategoria(
    int mudanzaId,
    String categoria,
  ) async {
    return _queryAdapter.queryList(
        'SELECT nombre FROM Item WHERE mudanzaId = ?1 AND categoria = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [mudanzaId, categoria]);
  }

  @override
  Future<Item?> obtenerItemPorId(int id) async {
    return _queryAdapter.query('SELECT * FROM Item WHERE itemId = ?1',
        mapper: (Map<String, Object?> row) => Item(
            itemId: row['itemId'] as int?,
            mudanzaId: row['mudanzaId'] as int,
            nombre: row['nombre'] as String,
            peso: row['peso'] as double?,
            foto: row['foto'] as String?,
            descripcion: row['descripcion'] as String?,
            gotIt: (row['gotIt'] as int) != 0,
            categoria: row['categoria'] as String?,
            estado: row['estado'] as String?),
        arguments: [id]);
  }

  @override
  Future<Item?> obtenerItemPorNombre(
    int mudanzaId,
    String categoria,
    String nombre,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Item WHERE mudanzaId = ?1 AND categoria = ?2 AND nombre = ?3 LIMIT 1',
        mapper: (Map<String, Object?> row) => Item(itemId: row['itemId'] as int?, mudanzaId: row['mudanzaId'] as int, nombre: row['nombre'] as String, peso: row['peso'] as double?, foto: row['foto'] as String?, descripcion: row['descripcion'] as String?, gotIt: (row['gotIt'] as int) != 0, categoria: row['categoria'] as String?, estado: row['estado'] as String?),
        arguments: [mudanzaId, categoria, nombre]);
  }

  @override
  Future<int?> contarItemsDeMudanza(int mudanzaId) async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Item WHERE mudanzaId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [mudanzaId]);
  }

  @override
  Future<int?> contarItemsPorCategoria(
    int mudanzaId,
    String categoria,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Item WHERE mudanzaId = ?1 AND categoria = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [mudanzaId, categoria]);
  }

  @override
  Future<int?> contarItemsGotIt(int id) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM Item WHERE mudanzaId = ?1 AND gotIt = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<bool?> existeItemConCategoria(
    int mudanzaId,
    String categoria,
  ) async {
    return _queryAdapter.query(
        'SELECT EXISTS(SELECT 1 FROM Item WHERE mudanzaId = ?1 AND categoria = ?2 LIMIT 1)',
        mapper: (Map<String, Object?> row) => (row.values.first as int) != 0,
        arguments: [mudanzaId, categoria]);
  }

  @override
  Future<void> eliminarItemPorId(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Item WHERE itemId = ?1', arguments: [id]);
  }

  @override
  Future<void> insertar(Item item) async {
    await _itemInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> actualizarItem(Item item) async {
    await _itemUpdateAdapter.update(item, OnConflictStrategy.abort);
  }
}

class _$MensajeDao extends MensajeDao {
  _$MensajeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _mensajeInsertionAdapter = InsertionAdapter(
            database,
            'Mensaje',
            (Mensaje item) => <String, Object?>{
                  'mensajeId': item.mensajeId,
                  'chatId': item.chatId,
                  'remitente': item.remitente,
                  'contenido': item.contenido,
                  'timestamp': item.timestamp
                }),
        _mensajeDeletionAdapter = DeletionAdapter(
            database,
            'Mensaje',
            ['mensajeId'],
            (Mensaje item) => <String, Object?>{
                  'mensajeId': item.mensajeId,
                  'chatId': item.chatId,
                  'remitente': item.remitente,
                  'contenido': item.contenido,
                  'timestamp': item.timestamp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Mensaje> _mensajeInsertionAdapter;

  final DeletionAdapter<Mensaje> _mensajeDeletionAdapter;

  @override
  Future<List<Mensaje>> obtenerTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Mensaje',
        mapper: (Map<String, Object?> row) => Mensaje(
            row['mensajeId'] as int?,
            row['chatId'] as int,
            row['remitente'] as String,
            row['contenido'] as String,
            row['timestamp'] as String));
  }

  @override
  Future<void> insertar(Mensaje mensaje) async {
    await _mensajeInsertionAdapter.insert(mensaje, OnConflictStrategy.abort);
  }

  @override
  Future<void> eliminar(Mensaje mensaje) async {
    await _mensajeDeletionAdapter.delete(mensaje);
  }
}

class _$ChatDao extends ChatDao {
  _$ChatDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _chatInsertionAdapter = InsertionAdapter(
            database,
            'Chat',
            (Chat item) => <String, Object?>{
                  'chatId': item.chatId,
                  'user1': item.user1,
                  'user2': item.user2
                }),
        _chatDeletionAdapter = DeletionAdapter(
            database,
            'Chat',
            ['chatId'],
            (Chat item) => <String, Object?>{
                  'chatId': item.chatId,
                  'user1': item.user1,
                  'user2': item.user2
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Chat> _chatInsertionAdapter;

  final DeletionAdapter<Chat> _chatDeletionAdapter;

  @override
  Future<List<Chat>> obtenerTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Chat',
        mapper: (Map<String, Object?> row) => Chat(row['chatId'] as int?,
            row['user1'] as String, row['user2'] as String));
  }

  @override
  Future<void> insertar(Chat chat) async {
    await _chatInsertionAdapter.insert(chat, OnConflictStrategy.abort);
  }

  @override
  Future<void> eliminar(Chat chat) async {
    await _chatDeletionAdapter.delete(chat);
  }
}

class _$ClientDao extends ClientDao {
  _$ClientDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _clientInsertionAdapter = InsertionAdapter(
            database,
            'Client',
            (Client item) => <String, Object?>{
                  'userId': item.userId,
                  'user': item.user,
                  'profilePhoto': item.profilePhoto
                }),
        _clientDeletionAdapter = DeletionAdapter(
            database,
            'Client',
            ['userId'],
            (Client item) => <String, Object?>{
                  'userId': item.userId,
                  'user': item.user,
                  'profilePhoto': item.profilePhoto
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Client> _clientInsertionAdapter;

  final DeletionAdapter<Client> _clientDeletionAdapter;

  @override
  Future<List<Client>> obtenerTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Client',
        mapper: (Map<String, Object?> row) => Client(
            userId: row['userId'] as String,
            user: row['user'] as String,
            profilePhoto: row['profilePhoto'] as String?));
  }

  @override
  Future<void> insertar(Client client) async {
    await _clientInsertionAdapter.insert(client, OnConflictStrategy.abort);
  }

  @override
  Future<void> eliminar(Client client) async {
    await _clientDeletionAdapter.delete(client);
  }
}
