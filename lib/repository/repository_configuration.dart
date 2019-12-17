import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookRepository.dart';
import 'package:ercoin_wallet/repository/database_provider.dart';
import 'package:injector/injector.dart';

class RepositoryConfiguration {
  static Future configure(Injector injector) async {
    final databaseInstance = await DatabaseProvider.initializeDatabase();

    injector.registerSingleton<AccountRepository>((_) => AccountRepository(databaseInstance));
    injector.registerSingleton<AddressBookRepository>((_) => AddressBookRepository(databaseInstance));
  }
}