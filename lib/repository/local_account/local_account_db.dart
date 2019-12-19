import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:sqflite/sqflite.dart';

class LocalAccountDb {
  static const tableName = "LocalAccount";
  static const publicKeyRow = "publicKey";
  static const privateKeyRow = "privateKey";
  static const nameRow = "name";

  static const createTableQuery = "CREATE TABLE $tableName(" +
      "$publicKeyRow varchar(${Address.requiredPublicKeyLength}) PRIMARY KEY, " +
      "$privateKeyRow varchar(${PrivateKey.requiredLength}), " +
      "$nameRow varchar(255));";

  static const _whereNameLikeClause = "$nameRow LIKE ?";
  static const _wherePublicKeyIsClause = "$publicKeyRow = ?";

  final Database _db;

  const LocalAccountDb(this._db);

  Future insert(Map<String, dynamic> data) async => await _db.insert(tableName, data);

  Future queryAll() async => await _db.query(tableName);

  Future queryByPublicKey(String publicKey) async =>
      await _db.query(tableName, where: _wherePublicKeyIsClause, whereArgs: [publicKey]);

  Future queryByNameContains(String value) async =>
      await _db.query(tableName, where: _whereNameLikeClause, whereArgs: ["%$value%"]);
}
