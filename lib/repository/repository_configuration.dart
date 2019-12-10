import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:injector/injector.dart';

class RepositoryConfiguration {
  static configure(Injector injector) {
    injector.registerSingleton<AccountRepository>((_) => AccountRepository());
    injector.registerSingleton<AddressRepository>((_) => AddressRepository());
  }
}