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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $accountsTable ( 
        ${accountsFields.id} $idType, 
        ${accountsFields.password} $textType, 
        ${accountsFields.isAuthenticated} $boolType,
        ${accountsFields.sidnumber} $integerType,
        ${accountsFields.eidnumber} $integerType,
        ${accountsFields.firstname} $textType,
        ${accountsFields.lastname} $textType,
        ${accountsFields.dispname} $textType,
        ${accountsFields.time} $textType
        )
      ''');
  }

  Future<account> create(account account) async {
    if ((account.sidnumber != null && account.eidnumber != null) ||
        (account.sidnumber == null && account.eidnumber == null)) {
      throw Exception('An account must have either sidnumber or eidnumber.');
    }

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

  Future<int> update(account account) async {
    if ((account.sidnumber != null && account.eidnumber != null) ||
        (account.sidnumber == null && account.eidnumber == null)) {
      throw Exception('An account must have either sidnumber or eidnumber.');
    }

    final db = await instance.database;

    return db.update(
      accountsTable,
      account.toJson(),
      where: '${accountsFields.id} = ?',
      whereArgs: [account.id],
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

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}