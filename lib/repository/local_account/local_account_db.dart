import 'package:sqflite/sqflite.dart';

class LocalAccountDb {
  static const tableName = "LocalAccount";
  static const publicKeyRow = "publicKey";
  static const privateKeyRow = "privateKey";
  static const nameRow = "name";

  static const createTableQuery = "CREATE TABLE $tableName(" +
      "$publicKeyRow varchar(255) PRIMARY KEY, " +
      "$privateKeyRow varchar(255), " +
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
