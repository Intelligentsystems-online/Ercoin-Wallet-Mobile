import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:injector/injector.dart';

class RepositoryConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
    _injector.registerSingleton<AccountRepository>((_) => AccountRepository());
    _injector.registerSingleton<AddressRepository>((_) => AddressRepository());
  }
}