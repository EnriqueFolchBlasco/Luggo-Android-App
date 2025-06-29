import 'package:luggo/database/app_database.dart';

class DatabaseService {
  static AppDatabase? _database;

  static Future<AppDatabase> getDatabase() async {
    _database ??= await $FloorAppDatabase.databaseBuilder('luggo.db').build();
    return _database!;
  }
}
