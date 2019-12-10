import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/add_account_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/configure_account_name/configure_account_name_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/import_account/import_account_interactor.dart';
import 'package:ercoin_wallet/interactor/address_list/AddressListInteractor.dart';
import 'package:ercoin_wallet/interactor/backup/backup_interactor.dart';
import 'package:ercoin_wallet/interactor/transaction_list/transaction_list_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/select_destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/transfer_interactor.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';
import 'package:injector/injector.dart';

class InteractorConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
    _injector.registerSingleton<AccountInfoInteractor>((injector) => AccountInfoInteractor(
      activeAccountService: injector.getDependency<ActiveAccountService>(),
      transactionListService: injector.getDependency<TransactionListService>()
    ));
    _injector.registerSingleton<AccountListInteractor>((injector) => AccountListInteractor(
      accountService: injector.getDependency<AccountService>(),
      activeAccountService: injector.getDependency<ActiveAccountService>()
    ));
    _injector.registerSingleton<AddAccountInteractor>((injector) => AddAccountInteractor(
      accountService: injector.getDependency<AccountService>()
    ));
    _injector.registerSingleton<ImportAccountInteractor>((_) => ImportAccountInteractor());
    _injector.registerSingleton<ConfigureAccountNameInteractor>((injector) => ConfigureAccountNameInteractor(
      accountService: injector.getDependency<AccountService>(),
      activeAccountService: injector.getDependency<ActiveAccountService>()
    ));
    _injector.registerSingleton<AddressListInteractor>((injector) => AddressListInteractor(
      addressService: injector.getDependency<AddressService>()
    ));
    _injector.registerSingleton<BackupInteractor>((_) => BackupInteractor());
    _injector.registerSingleton<TransactionListInteractor>((_) => TransactionListInteractor());
    _injector.registerSingleton<SelectTransferDestinationInteractor>((injector) => SelectTransferDestinationInteractor(
      addressService: injector.getDependency<AddressService>()
    ));
    _injector.registerSingleton<TransferInteractor>((injector) => TransferInteractor(
      activeAccountService: injector.getDependency<ActiveAccountService>(),
      transferService: injector.getDependency<TransferService>()
    ));
  }
}