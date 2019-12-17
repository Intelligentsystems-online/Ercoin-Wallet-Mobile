import 'dart:async';

import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/local_account.dart';
import 'package:ercoin_wallet/model/named_address.dart';
import 'package:ercoin_wallet/model/private_key.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_db.dart';

import 'package:sqflite/sqflite.dart';

class LocalAccountRepository {
  final Database _database;

  const LocalAccountRepository(this._database);

  Future<LocalAccount> create(Address address, String name, PrivateKey privateKey) async {
    final localAccount = LocalAccount(
        namedAddress: NamedAddress(address: address, name: name), 
        privateKey: privateKey
    );
    await _database.insert(LocalAccountDb.tableName, LocalAccountDb.serialize(localAccount));
    return localAccount;
  }

  Future<List<LocalAccount>> findAll() async => _deserialize(await _database.query(LocalAccountDb.tableName));

  Future<LocalAccount> findByAddress(Address address) async => _deserializeExactlyOne(await _database.query(
        LocalAccountDb.tableName,
        where: LocalAccountDb.wherePublicKeyIsClause,
        whereArgs: [address.publicKey],
      ));

  Future<List<LocalAccount>> findByNameContains(String value) async => _deserialize(await _database.query(
        LocalAccountDb.tableName,
        where: LocalAccountDb.whereNameLikeClause,
        whereArgs: ["%$value%"],
      ));

  List<LocalAccount> _deserialize(List<Map<String, dynamic>> dataList) =>
      dataList.map((data) => LocalAccountDb.deserialize(data)).toList();

  LocalAccount _deserializeExactlyOne(List<Map<String, dynamic>> dataList) =>
      dataList.length == 1 ? _deserialize(dataList).first : throw Exception("Account not found");
}
