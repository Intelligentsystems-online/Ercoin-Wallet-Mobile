import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:sqflite/sqflite.dart';

class NamedAddressDb {
  static const tableName = "NamedAddress";
  static const publicKeyRow = "publicKey";
  static const nameRow = "name";

  static const createTableQuery = "CREATE TABLE $tableName (" +
      "$publicKeyRow varchar(${Address.requiredPublicKeyLength}) PRIMARY KEY, " +
      "$nameRow varchar(255));";

  static const _whereNameLikeClause = "$nameRow LIKE ?";
  static const _wherePublicKeyIsClause = "$publicKeyRow = ?";
  
  final Database _db;
  
  const NamedAddressDb(this._db);
  
  Future insert(Map<String, dynamic> data) async => await _db.insert(tableName, data);
  
  Future queryAll() async => await _db.query(tableName);
  
  Future queryByNameContains(String value) async => 
      await _db.query(tableName, where: _whereNameLikeClause, whereArgs: ["%$value%"]);
  
  Future queryByPublicKey(String publicKey) async =>
      await _db.query(tableName, where: _wherePublicKeyIsClause, whereArgs: [publicKey]);
}
