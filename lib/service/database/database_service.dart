import 'package:ercoin_wallet/repository/local_account/local_account_db.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_db.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database _database;

  Database obtainDatabase() => _database ?? (throw Exception("Database not initialized"));

  Future initialize() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ErcoinWallet.db");

    _database = await openDatabase(
        path,
        version: 1,
        onOpen: (_) {},
        onCreate: (Database database, int version) async {
          await database.execute(LocalAccountDb.createTableQuery);
          await database.execute(NamedAddressDb.createTableQuery);
        }
    );
  }
}
