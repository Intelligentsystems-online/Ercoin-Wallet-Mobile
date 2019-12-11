import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookRepository.dart';
import 'package:injector/injector.dart';

class RepositoryConfiguration {
  static configure(Injector injector) {
    injector.registerSingleton<AccountRepository>((_) => AccountRepository());
    injector.registerSingleton<AddressBookRepository>((_) => AddressBookRepository());
  }
}