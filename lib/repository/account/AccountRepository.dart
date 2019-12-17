import 'dart:async';

import 'package:ercoin_wallet/repository/account/Account.dart';

import 'package:sqflite/sqflite.dart';

class AccountRepository
{
  static final _tableName = "Account";

  final Database _database;

  AccountRepository(this._database);

  Future<Account> createAccount(String publicKey, String privateKey, String accountName) {
    final account = Account(publicKey, privateKey, accountName);

    return _database
        .insert(_tableName, account.toMap())
        .then((_) => account);
  }

  Future<List<Account>> findAll() async => _database
      .query(_tableName)
      .then((response) => _prepareEntryFrom(response));

  Future<Account> findByPublicKey(String publicKey) async {
    final response = await _database
        .query("Account", where: "publicKey = ?", whereArgs: [publicKey]);

    return response.isNotEmpty ? Account.fromMap(response.first) : Null;
  }

  List<Account> _prepareEntryFrom(List<Map<String, dynamic>> response) =>
      response.isNotEmpty ? response.map((account) => Account.fromMap(account)).toList() : [];
}
