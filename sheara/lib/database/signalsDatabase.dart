import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/helpSignal.dart';

class helpSignalsDatabase {
  static final helpSignalsDatabase instance = helpSignalsDatabase._init();

  static Database? _database;

  helpSignalsDatabase._init();



  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('accounts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion == 1) {
      }
      await db.execute('PRAGMA user_version = $newVersion');
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER';

    await db.execute('''
    CREATE TABLE $signalsTable ( 
      ${signalsFields.id} $idType,
      PRIMARY KEY(${signalsFields.id},
      ${signalsFields.displayName} $textType,
      ${signalsFields.values[1]} ${integerType},
      lastSeenLocations TEXT NOT NULL,
      )
    )
  ''');
  }

  Future<helpSignal> create(helpSignal account) async {
    final db = await instance.database;
    final id = await db.insert(signalsTable, account.toJson());

    return account.copy(id: id);
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}
