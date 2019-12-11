import 'dart:async';

import 'package:ercoin_wallet/repository/DatabaseProvider.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';

import 'package:sqflite/sqflite.dart';

class AddressBookRepository
{
  final _tableName = "AddressBook";

  Future<AddressBookEntry> createAddressBookEntry(String publicKey, String accountName) {
    AddressBookEntry address = AddressBookEntry(publicKey, accountName);

    return DatabaseProvider
        .databaseProvider
        .databaseInstance
        .then((database) => executeInsertQueryOn(database, address))
        .then((_) => address);
  }

  Future<List<AddressBookEntry>> findAll() => DatabaseProvider
      .databaseProvider
      .databaseInstance
      .then((database) => executeFindAllQueryOn(database));

  Future<int> executeInsertQueryOn(Database database, AddressBookEntry address) => database
      .insert(_tableName, address.toMap());

  Future<List<AddressBookEntry>> executeFindAllQueryOn(Database database) => database
      .query(_tableName)
      .then((response) => prepareEntryFrom(response));

  List<AddressBookEntry> prepareEntryFrom(List<Map<String, dynamic>> response) =>
      response.isNotEmpty ? response.map((address) => AddressBookEntry.fromMap(address)).toList() : [];
}