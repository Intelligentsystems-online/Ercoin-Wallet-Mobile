import 'dart:async';

import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';

import 'package:sqflite/sqflite.dart';

class AddressBookRepository
{
  final _tableName = "AddressBook";

  Database _database;

  AddressBookRepository(this._database);

  Future<AddressBookEntry> createAddressBookEntry(String publicKey, String accountName) {
    AddressBookEntry address = AddressBookEntry(publicKey, accountName);

    return _database
        .insert(_tableName, address.toMap())
        .then((_) => address);
  }

  Future<List<AddressBookEntry>> findAll() => _database
      .query(_tableName)
      .then((response) => prepareEntryFrom(response));

  List<AddressBookEntry> prepareEntryFrom(List<Map<String, dynamic>> response) =>
      response.isNotEmpty ? response.map((address) => AddressBookEntry.fromMap(address)).toList() : [];
}