import 'package:ercoin_wallet/repository/local_account/local_account_db.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_db.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_repository.dart';
import 'package:injector/injector.dart';
import 'package:sqflite/sqlite_api.dart';

class RepositoriesConfiguration {
  static configure(Injector injector) {
    injector.registerSingleton<LocalAccountDb>((injector) => LocalAccountDb(injector.getDependency<Database>()));
    injector.registerSingleton<LocalAccountRepository>((injector) => LocalAccountRepository(
          injector.getDependency<LocalAccountDb>(),
        ));
    injector.registerSingleton<NamedAddressDb>((injector) => NamedAddressDb(injector.getDependency<Database>()));
    injector.registerSingleton<NamedAddressRepository>((_) => NamedAddressRepository(
          injector.getDependency<NamedAddressDb>(),
        ));
  }
}
