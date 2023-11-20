import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/account.dart';

class accountsDatabase {
  static final accountsDatabase instance = accountsDatabase._init();

  static Database? _database;

  accountsDatabase._init();

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
    CREATE TABLE $accountsTable ( 
      ${accountsFields.id} $idType, 
      ${accountsFields.password} $textType, 
      ${accountsFields.isAuthenticated} $boolType,
      ${accountsFields.isStudent} $boolType,
      ${accountsFields.idNumber} $integerType UNIQUE,
      ${accountsFields.firstname} $textType,
      ${accountsFields.lastname} $textType,
      ${accountsFields.dispname} $textType,
      ${accountsFields.favColor} $textType,
      ${accountsFields.time} $textType,
      ${accountsFields.lastSeenLocation} $textType,
      ${accountsFields.lastSeenTime} $textType,
      ${accountsFields.needsHelp} $boolType
    )
  ''');
  }

  Future<account> create(account account) async {
    final db = await instance.database;
    final id = await db.insert(accountsTable, account.toJson());

    return account.copy(id: id);
  }

  Future<account> viewAccount(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      accountsTable,
      columns: accountsFields.values,
      where: '${accountsFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return account.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<account?> getAccount(int idNumber, bool isStudent, String password) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      accountsTable,
      columns: accountsFields.values,
      where: '${accountsFields.idNumber} = ? AND ${accountsFields.isStudent} = ? AND ${accountsFields.password} = ?',
      whereArgs: [idNumber, isStudent ? 1 : 0, password],
    );

    if (maps.isNotEmpty) {
      return account.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(account account) async {
    final db = await instance.database;

    return db.update(
      accountsTable,
      account.toJson(),
      where: '${accountsFields.id} = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> updateAuthenticationStatus(int accountId, bool isAuthenticated) async {
    final db = await instance.database;

    await db.update(
      accountsTable,
      {accountsFields.isAuthenticated: isAuthenticated ? 1 : 0},
      where: '${accountsFields.id} = ?',
      whereArgs: [accountId],
    );
  }


  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      accountsTable,
      where: '${accountsFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<account>> getAllAccounts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(accountsTable);

    return List.generate(maps.length, (i) {
      return account(
        id: maps[i][accountsFields.id],
        password: maps[i][accountsFields.password],
        isAuthenticated: maps[i][accountsFields.isAuthenticated] == 1,
        isStudent: maps[i][accountsFields.isStudent] == 1,
        idNumber: maps[i][accountsFields.idNumber],
        firstname: maps[i][accountsFields.firstname],
        lastname: maps[i][accountsFields.lastname],
        dispname: maps[i][accountsFields.dispname],
        favColor: maps[i][accountsFields.favColor],
        timeCreated: DateTime.parse(maps[i][accountsFields.time]),
        lastSeenLocation: maps[i][accountsFields.lastSeenLocation],
        lastSeenTime: DateTime.parse(maps[i][accountsFields.lastSeenTime]),
        needsHelp: maps[i][accountsFields.needsHelp],
      );
    });
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}