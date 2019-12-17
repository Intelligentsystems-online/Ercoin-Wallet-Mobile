import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/repository/database_provider.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_repository.dart';
import 'package:injector/injector.dart';

class RepositoryConfiguration {
  static Future configure(Injector injector) async {
    final databaseInstance = await DatabaseProvider.initializeDatabase();

    injector.registerSingleton<LocalAccountRepository>((_) => LocalAccountRepository(databaseInstance));
    injector.registerSingleton<NamedAddressRepository>((_) => NamedAddressRepository(databaseInstance));
  }
}
