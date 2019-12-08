import 'dart:async';

import 'package:ercoin_wallet/repository/DatabaseProvider.dart';
import 'package:ercoin_wallet/repository/address/Address.dart';

import 'package:sqflite/sqflite.dart';

class AddressRepository
{
  final _tableName = "Address";

  Future<Address> createAddress(String publicKey, String accountName) {
    Address address = Address(publicKey, accountName);

    return DatabaseProvider
        .databaseProvider
        .databaseInstance
        .then((database) => executeInsertQueryOn(database, address))
        .then((_) => address);
  }

  Future<List<Address>> findAll() => DatabaseProvider
      .databaseProvider
      .databaseInstance
      .then((database) => executeFindAllQueryOn(database));

  Future<int> executeInsertQueryOn(Database database, Address address) => database
      .insert(_tableName, address.toMap());

  Future<List<Address>> executeFindAllQueryOn(Database database) => database
      .query(_tableName)
      .then((response) => prepareAddressesFrom(response));

  List<Address> prepareAddressesFrom(List<Map<String, dynamic>> response) =>
      response.isNotEmpty ? response.map((address) => Address.fromMap(address)).toList() : [];
}