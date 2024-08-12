import 'package:forleha/services/db_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  Database? _database;
  static const int _version = 3;
  static const String _dbName = 'db_orders';

  Future<Database> initialize() async {
    final path = await fullPath;

    var database = await openDatabase(
      path,
      version: _version,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }
  Future<String> get fullPath async {
    const name = _dbName;
    final path = await getDatabasesPath();
    return join(path,name);
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initialize();
    return _database!;
  }

  Future<void> create(Database database, int version) async =>
    await DatabaseTable().createTable(database);

}
