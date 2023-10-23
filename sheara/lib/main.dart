import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import '../database/accountsDatabase.dart';
import '../model/account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = accountsDatabase.instance;

  await database.database;

  final trial = account(
    password: 'xdding',
    isAuthenticated: true,
    sidnumber: 201902151,
    eidnumber: 0,
    firstname: 'Hadjie',
    lastname: 'Bernales',
    dispname: 'Boang',
    timeCreated: DateTime.now(),
  );

  final createdAccount = await database.create(trial);
  print('Created Account: $createdAccount');

  final retrievedAccount = await database.viewAccount(createdAccount.id!);
  print('Retrieved Account: $retrievedAccount');

  final updatedAccount = retrievedAccount.copy(firstname: 'Jane');
  final rowsAffected = await database.update(updatedAccount);
  print('Rows Updated: $rowsAffected');

  final accountAfterUpdate = await database.viewAccount(updatedAccount.id!);
  print('Account After Update: $accountAfterUpdate');

  final rowsDeleted = await database.delete(accountAfterUpdate.id!);
  print('Rows Deleted: $rowsDeleted');

  await database.close();
}
