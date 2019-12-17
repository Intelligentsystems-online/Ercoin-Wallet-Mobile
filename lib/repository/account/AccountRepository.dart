import 'dart:async';

import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/table/account_table.dart';

import 'package:sqflite/sqflite.dart';

class AccountRepository
{
  final Database _database;

  AccountRepository(this._database);

  Future<Account> createAccount(String publicKey, String privateKey, String accountName) {
    final account = Account(publicKey, privateKey, accountName);

    return _database
        .insert(AccountTable.tableName, account.toMap())
        .then((_) => account);
  }

  Future<List<Account>> findAll() async => _database
      .query(AccountTable.tableName)
      .then((response) => _prepareEntryFrom(response));

  Future<Account> findByPublicKey(String publicKey) async {
    final response = await _database
        .query(AccountTable.tableName, where: "${AccountTable.publicKeyField} = ?", whereArgs: [publicKey]);

    return response.isNotEmpty ? Account.fromMap(response.first) : Null;
  }

  List<Account> _prepareEntryFrom(List<Map<String, dynamic>> response) =>
      response.isNotEmpty ? response.map((account) => Account.fromMap(account)).toList() : [];
}
