import 'dart:io';

import 'package:ercoin_wallet/repository/table/account_table.dart';
import 'package:ercoin_wallet/repository/table/address_book_table.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ErcoinWallet.db");

    return openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database database, int version) {
          _executeQuery(database, AccountTable.createTableQuery);
          _executeQuery(database, AddressBookTable.createTableQuery);
        }
    );
  }

  static _executeQuery(Database database, String query) async {
    await database.execute(query);
  }
}