import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/add_account_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/configure_account_name/configure_account_name_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/import_account/import_account_interactor.dart';
import 'package:ercoin_wallet/interactor/address_book/address_book_interactor.dart';
import 'package:ercoin_wallet/interactor/backup/backup_interactor.dart';
import 'package:ercoin_wallet/interactor/enter_address_book_entry/enter_address_book_entry_interactor.dart';
import 'package:ercoin_wallet/interactor/transaction_list/transaction_list_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/select_destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/transfer_interactor.dart';
import 'package:ercoin_wallet/utils/service/account/local_account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_local_account_service.dart';
import 'package:ercoin_wallet/utils/service/account/local_account_details_util.dart';
import 'package:ercoin_wallet/utils/service/addressBook/named_address_service.dart';
import 'package:ercoin_wallet/utils/service/common/keys_validation_util.dart';
import 'package:ercoin_wallet/utils/service/file/file_util.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';
import 'package:injector/injector.dart';

class InteractorConfiguration {
  static configure(Injector injector) {
    injector.registerSingleton<AccountInfoInteractor>((injector) => AccountInfoInteractor(
      injector.getDependency<ActiveAccountService>(),
      injector.getDependency<TransactionListService>()
    ));
    injector.registerSingleton<AccountListInteractor>((injector) => AccountListInteractor(
      injector.getDependency<AccountService>(),
      injector.getDependency<ActiveAccountService>()
    ));
    injector.registerSingleton<AddAccountInteractor>((injector) => AddAccountInteractor(
      injector.getDependency<AccountService>()
    ));
    injector.registerSingleton<ImportAccountInteractor>((_) => ImportAccountInteractor(
      injector.getDependency<AccountService>(),
      injector.getDependency<FileUtil>(),
      injector.getDependency<KeysValidationUtil>()
    ));
    injector.registerSingleton<ConfigureAccountNameInteractor>((injector) => ConfigureAccountNameInteractor(
      injector.getDependency<AccountService>(),
      injector.getDependency<ActiveAccountService>()
    ));
    injector.registerSingleton<AddressBookInteractor>((injector) => AddressBookInteractor(
      injector.getDependency<AddressBookService>()
    ));
    injector.registerSingleton<BackupInteractor>((_) => BackupInteractor());
    injector.registerSingleton<EnterAddressBookEntryInteractor>((injector) => EnterAddressBookEntryInteractor(
      injector.getDependency<AddressBookService>(),
      injector.getDependency<KeysValidationUtil>()
    ));
    injector.registerSingleton<TransactionListInteractor>((_) => TransactionListInteractor(
        injector.getDependency<ActiveAccountService>(),
        injector.getDependency<TransactionListService>()
    ));
    injector.registerSingleton<SelectTransferDestinationInteractor>((injector) => SelectTransferDestinationInteractor(
      injector.getDependency<AddressBookService>()
    ));
    injector.registerSingleton<TransferInteractor>((injector) => TransferInteractor(
      injector.getDependency<ActiveAccountService>(),
      injector.getDependency<TransferService>()
    ));
  }
}
