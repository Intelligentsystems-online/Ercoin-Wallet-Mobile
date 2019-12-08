import 'dart:async';

import 'package:ercoin_wallet/repository/DatabaseProvider.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';

class AccountRepository
{
  Future<Account> createAccount(String publicKey, String privateKey, String accountName) {
    final account = Account(publicKey, privateKey, accountName);

    return DatabaseProvider
        .databaseProvider
        .databaseInstance
        .then((database) => database.insert("Account", account.toMap()))
        .then((_) => account);
  }
  Future<List<Account>> findAll() async {
    final database = await DatabaseProvider.databaseProvider.databaseInstance;

    var response = await database.query("Account");

    return response.isNotEmpty ? response.map((account) => Account.fromMap(account)).toList() : [];
  }

  Future<Account> findByPublicKey(String publicKey) async {
    final database = await DatabaseProvider.databaseProvider.databaseInstance;

    var response = await  database.query("Account", where: "publicKey = ?", whereArgs: [publicKey]);

    return response.isNotEmpty ? Account.fromMap(response.first) : Null;
  }
}
