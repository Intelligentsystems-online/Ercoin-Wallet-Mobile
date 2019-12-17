import 'dart:async';

import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/named_address.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_db.dart';

import 'package:sqflite/sqflite.dart';

class NamedAddressRepository
{
  Database _database;

  NamedAddressRepository(this._database);

  Future<NamedAddress> create(Address address, String name) async {
    final namedAddress = NamedAddress(address: address, name: name);
    await _database.insert(NamedAddressDb.tableName, NamedAddressDb.serialize(namedAddress));
    return namedAddress;
  }

  Future<List<NamedAddress>> findAll() async =>
    _deserialize(await _database.query(NamedAddressDb.tableName));

  Future<List<NamedAddress>> findByNameContains(String value) async =>
    _deserialize(await _database.query(
        NamedAddressDb.tableName,
        where: NamedAddressDb.whereNameLikeClause,
        whereArgs: ["%$value%"],
    ));

  List<NamedAddress> _deserialize(List<Map<String, dynamic>> response) =>
      response.map((data) => NamedAddressDb.deserialize(data)).toList();
}
