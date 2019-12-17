import 'package:ercoin_wallet/repository/account/local_account_repository.dart';
import 'package:ercoin_wallet/repository/addressBook/named_address_repository.dart';
import 'package:ercoin_wallet/service/account/local_account_service.dart';
import 'package:ercoin_wallet/service/account/active_local_account_service.dart';
import 'package:ercoin_wallet/service/account/local_account_details_util.dart';
import 'package:ercoin_wallet/service/addressBook/named_address_service.dart';
import 'package:ercoin_wallet/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/service/api/code_mapper_util.dart';
import 'package:ercoin_wallet/service/api/uri_factory.dart';
import 'package:ercoin_wallet/service/common/byte_converter_service.dart';
import 'package:ercoin_wallet/service/common/date_util.dart';
import 'package:ercoin_wallet/service/common/key_generator.dart';
import 'package:ercoin_wallet/service/common/keys_validation_util.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_util.dart';
import 'package:ercoin_wallet/service/file/file_util.dart';
import 'package:ercoin_wallet/service/transaction/list/transaction_list_service.dart';
import 'package:ercoin_wallet/service/transaction/api/transfer_data_decoding_service.dart';
import 'package:ercoin_wallet/service/transaction/api/transfer_data_encoding_service.dart';
import 'package:ercoin_wallet/service/transaction/transfer_signing_service.dart';
import 'package:ercoin_wallet/service/transaction/transfer/transfer_service.dart';
import 'package:injector/injector.dart';

class ServiceUtilsConfiguration {
  static configure(Injector injector) {
    _configureFile(injector);
    _configureCommon(injector);
    _configureApi(injector);
    _configureAccount(injector);
    _configureAddress(injector);
    _configureTransaction(injector);
  }

  static _configureFile(Injector injector) {
    injector.registerSingleton<FileUtil>((_) => FileUtil());
  }

  static _configureCommon(Injector injector) {
    injector.registerSingleton<ByteConverterService>((_) => ByteConverterService());
    injector.registerSingleton<DateUtil>((_) => DateUtil());
    injector.registerSingleton<KeyGenerator>((_) => KeyGenerator());
    injector.registerSingleton<KeysValidationUtil>((_) => KeysValidationUtil());
    injector.registerSingleton<SharedPreferencesUtil>((_) => SharedPreferencesUtil());
  }

  static _configureApi(Injector injector) {
    injector.registerSingleton<CodeMapperUtil>((_) => CodeMapperUtil());
    injector.registerSingleton<UriFactory>((_) => UriFactory());
    injector.registerSingleton<ApiConsumerService>((injector) => ApiConsumerService(
        injector.getDependency<CodeMapperUtil>(),
        injector.getDependency<UriFactory>()
    ));
  }

  static _configureAccount(Injector injector) {
    injector.registerSingleton<CommonAccountUtil>((_) => CommonAccountUtil());
    injector.registerSingleton<ActiveAccountService>((injector) => ActiveAccountService(
        injector.getDependency<CommonAccountUtil>(),
        injector.getDependency<LocalAccountRepository>(),
        injector.getDependency<ApiConsumerService>(),
        injector.getDependency<SharedPreferencesUtil>()
    ));
    injector.registerSingleton<AccountService>((injector) => AccountService(
        injector.getDependency<CommonAccountUtil>(),
        injector.getDependency<LocalAccountRepository>(),
        injector.getDependency<ApiConsumerService>(),
        injector.getDependency<KeyGenerator>()
    ));
  }

  static _configureAddress(Injector injector) {
    injector.registerSingleton<AddressBookService>((injector) => AddressBookService(
        injector.getDependency<AddressBookRepository>()
    ));
  }

  static _configureTransaction(Injector injector) {
    injector.registerSingleton<TransferDecodingService>((_) => TransferDecodingService());
    injector.registerSingleton<TransferEncodingService>((injector) => TransferEncodingService(
        injector.getDependency<ByteConverterService>()
    ));
    injector.registerSingleton<TransactionFactory>((injector) => TransactionFactory(
        injector.getDependency<TransferDecodingService>(),
        injector.getDependency<TransferEncodingService>()
    ));
    injector.registerSingleton<TransferService>((injector) => TransferService(
        injector.getDependency<TransferEncodingService>(),
        injector.getDependency<LocalAccountRepository>(),
        injector.getDependency<ApiConsumerService>()
    ));
    injector.registerSingleton<TransactionListService>((injector) => TransactionListService(
        injector.getDependency<TransactionFactory>(),
        injector.getDependency<ApiConsumerService>()
    ));
  }
}
