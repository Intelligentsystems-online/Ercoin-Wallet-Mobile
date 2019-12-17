import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookRepository.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/addressBook/address_book_service.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/api/code_mapper_util.dart';
import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';
import 'package:ercoin_wallet/utils/service/common/byte_converter.dart';
import 'package:ercoin_wallet/utils/service/common/date_util.dart';
import 'package:ercoin_wallet/utils/service/common/key_generator.dart';
import 'package:ercoin_wallet/utils/service/common/keys_validation_util.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';
import 'package:ercoin_wallet/utils/service/file/file_util.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_decode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_encode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_factory.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';
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
    injector.registerSingleton<ByteConverter>((_) => ByteConverter());
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
        injector.getDependency<AccountRepository>(),
        injector.getDependency<ApiConsumerService>(),
        injector.getDependency<SharedPreferencesUtil>()
    ));
    injector.registerSingleton<AccountService>((injector) => AccountService(
        injector.getDependency<CommonAccountUtil>(),
        injector.getDependency<AccountRepository>(),
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
    injector.registerSingleton<TransactionDecodeService>((_) => TransactionDecodeService());
    injector.registerSingleton<TransactionEncodeService>((injector) => TransactionEncodeService(
        injector.getDependency<ByteConverter>()
    ));
    injector.registerSingleton<TransactionFactory>((injector) => TransactionFactory(
        injector.getDependency<TransactionDecodeService>(),
        injector.getDependency<TransactionEncodeService>()
    ));
    injector.registerSingleton<TransferService>((injector) => TransferService(
        injector.getDependency<TransactionEncodeService>(),
        injector.getDependency<AccountRepository>(),
        injector.getDependency<ApiConsumerService>()
    ));
    injector.registerSingleton<TransactionListService>((injector) => TransactionListService(
        injector.getDependency<TransactionFactory>(),
        injector.getDependency<ApiConsumerService>()
    ));
  }
}