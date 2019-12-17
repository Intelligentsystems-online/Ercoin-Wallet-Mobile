import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
//  DatabaseProvider._();
//  static final DatabaseProvider databaseProvider = DatabaseProvider._();
//  static Database database;
//
//  Future<Database> get databaseInstance async =>
//      database == null ? await _initializeDatabase() : database;
//
//  Database _database;


  static Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ErcoinWallet.db");

    return openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database database, int version) {
          _executeQuery(database, accountTableQuery());
          _executeQuery(database, addressBookTableQuery());
        }
    );
  }

  static _executeQuery(Database database, String query) async {
    await database.execute(query);
  }

  static String accountTableQuery() =>
      "CREATE TABLE Account ("
          "publicKey varchar(255) PRIMARY KEY,"
          "privateKey varchar(255),"
          "accountName varchar(255));";

  static String addressBookTableQuery() =>
      "CREATE TABLE AddressBook ("
          "publicKey varchar(255) PRIMARY KEY,"
          "accountName varchar(255));";
}