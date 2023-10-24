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
      ${accountsFields.sidnumber} $integerType UNIQUE,
      ${accountsFields.eidnumber} $integerType UNIQUE,
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

  Future<account?> getAccountByIdAndType(int id, String userType) async {
    final db = await instance.database;

    // Determine the correct column based on the user type
    String idColumn = (userType == 'Student') ? accountsFields.sidnumber : accountsFields.eidnumber;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        accountsTable,
        columns: accountsFields.values,
        where: '$idColumn = ? AND $idColumn IS NOT NULL',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return account.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      print('Error in getAccountByIdAndType: $e');
      throw Exception('Error occurred while fetching account information.');
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
        sidnumber: maps[i][accountsFields.sidnumber],
        eidnumber: maps[i][accountsFields.eidnumber],
        firstname: maps[i][accountsFields.firstname],
        lastname: maps[i][accountsFields.lastname],
        dispname: maps[i][accountsFields.dispname],
        timeCreated: DateTime.parse(maps[i][accountsFields.time]),
      );
    });
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}