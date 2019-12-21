import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/add_account_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/configure_account_name/configure_account_name_interactor.dart';
import 'package:ercoin_wallet/interactor/add_account/import_account/import_account_interactor.dart';
import 'package:ercoin_wallet/interactor/add_address/add_address_interactor.dart';
import 'package:ercoin_wallet/interactor/address_book/address_book_interactor.dart';
import 'package:ercoin_wallet/interactor/backup/backup_interactor.dart';
import 'package:ercoin_wallet/interactor/enter_address/enter_address_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/destination/enter_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer/transfer_interactor.dart';
import 'package:ercoin_wallet/interactor/transfer_list/transfer_list_interactor.dart';
import 'package:ercoin_wallet/service/common/key_generator_service.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/file/json_file_service.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';
import 'package:injector/injector.dart';

class InteractorsConfiguration {
  static configure(Injector injector) {
    injector.registerSingleton<AccountInfoInteractor>((injector) => AccountInfoInteractor(
      injector.getDependency<ActiveLocalAccountService>(),
      injector.getDependency<TransferService>()
    ));
    injector.registerSingleton<AccountListInteractor>((injector) => AccountListInteractor(
      injector.getDependency<LocalAccountService>(),
      injector.getDependency<ActiveLocalAccountService>()
    ));
    injector.registerSingleton<AddAccountInteractor>((injector) => AddAccountInteractor(
      injector.getDependency<KeyGeneratorService>()
    ));
    injector.registerSingleton<ImportAccountInteractor>((_) => ImportAccountInteractor(
      injector.getDependency<LocalAccountService>(),
      injector.getDependency<JsonFileService>(),
      injector.getDependency<KeysFormatValidatorService>()
    ));
    injector.registerSingleton<ConfigureAccountNameInteractor>((injector) => ConfigureAccountNameInteractor(
      injector.getDependency<LocalAccountService>(),
      injector.getDependency<ActiveLocalAccountService>()
    ));
    injector.registerSingleton<AddressBookInteractor>((injector) => AddressBookInteractor(
      injector.getDependency<NamedAddressService>()
    ));
    injector.registerSingleton<BackupInteractor>((_) => BackupInteractor());
    injector.registerSingleton<EnterAddressFormInteractor>((injector) => EnterAddressFormInteractor(
      injector.getDependency<NamedAddressService>(),
      injector.getDependency<KeysFormatValidatorService>()
    ));
    injector.registerSingleton<TransferListInteractor>((_) => TransferListInteractor(
        injector.getDependency<TransferService>()
    ));
    injector.registerSingleton<SelectTransferDestinationInteractor>((injector) => SelectTransferDestinationInteractor(
      injector.getDependency<NamedAddressService>()
    ));
    injector.registerSingleton<TransferInteractor>((injector) => TransferInteractor(
      injector.getDependency<TransferService>()
    ));
    injector.registerSingleton<AddAddressIntractor>((injector) => AddAddressIntractor(
      injector.getDependency<NamedAddressService>(),
    ));
    injector.registerSingleton<EnterTransferDestinationInteractor>((injector) => EnterTransferDestinationInteractor(
      injector.getDependency<NamedAddressService>(),
    ));
  }
}
