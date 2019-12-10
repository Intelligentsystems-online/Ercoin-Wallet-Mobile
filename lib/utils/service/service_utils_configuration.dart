import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/api/code_mapper_util.dart';
import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';
import 'package:ercoin_wallet/utils/service/common/byte_converter.dart';
import 'package:ercoin_wallet/utils/service/common/date_util.dart';
import 'package:ercoin_wallet/utils/service/common/key_generator.dart';
import 'package:ercoin_wallet/utils/service/common/keys_validation_util.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_decode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_encode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_factory.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';
import 'package:injector/injector.dart';

class ServiceUtilsConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
    _commonConfiguration();
    _apiConfiguration();
    _accountConfiguration();
    _addressConfiguration();
    _transactionConfiguration();
  }

  _commonConfiguration() {
    _injector.registerSingleton<ByteConverter>((_) => ByteConverter());
    _injector.registerSingleton<DateUtil>((_) => DateUtil());
    _injector.registerSingleton<KeyGenerator>((_) => KeyGenerator());
    _injector.registerSingleton<KeysValidationUtil>((_) => KeysValidationUtil());
    _injector.registerSingleton<SharedPreferencesUtil>((_) => SharedPreferencesUtil());
  }

  _apiConfiguration() {
    _injector.registerSingleton<CodeMapperUtil>((_) => CodeMapperUtil());
    _injector.registerSingleton<UriFactory>((_) => UriFactory());
    _injector.registerSingleton<ApiConsumerService>((injector) => ApiConsumerService(
        codeMapperUtil: injector.getDependency<CodeMapperUtil>(),
        uriFactory: injector.getDependency<UriFactory>()
    ));
  }

  _accountConfiguration() {
    _injector.registerSingleton<CommonAccountUtil>((_) => CommonAccountUtil());
    _injector.registerSingleton<ActiveAccountService>((injector) => ActiveAccountService(
        commonAccountUtil: injector.getDependency<CommonAccountUtil>(),
        accountRepository: injector.getDependency<AccountRepository>(),
        apiConsumerService: injector.getDependency<ApiConsumerService>(),
        sharedPreferencesUtil: injector.getDependency<SharedPreferencesUtil>()
    ));
    _injector.registerSingleton<AccountService>((injector) => AccountService(
        commonAccountUtil: injector.getDependency<CommonAccountUtil>(),
        accountRepository: injector.getDependency<AccountRepository>(),
        apiConsumerService: injector.getDependency<ApiConsumerService>(),
        keyGenerator: injector.getDependency<KeyGenerator>()
    ));
  }

  _addressConfiguration() {
    _injector.registerSingleton<AddressService>((injector) => AddressService(
        addressRepository: injector.getDependency<AddressRepository>()
    ));
  }

  _transactionConfiguration() {
    _injector.registerSingleton<TransactionDecodeService>((_) => TransactionDecodeService());
    _injector.registerSingleton<TransactionEncodeService>((injector) => TransactionEncodeService(
        byteConverter: injector.getDependency<ByteConverter>()
    ));
    _injector.registerSingleton<TransactionFactory>((injector) => TransactionFactory(
        transactionDecodeService: injector.getDependency<TransactionDecodeService>(),
        transactionEncodeService: injector.getDependency<TransactionEncodeService>()
    ));
    _injector.registerSingleton<TransferService>((injector) => TransferService(
        transactionEncodeService: injector.getDependency<TransactionEncodeService>(),
        accountRepository: injector.getDependency<AccountRepository>(),
        apiConsumerService: injector.getDependency<ApiConsumerService>()
    ));
    _injector.registerSingleton<TransactionListService>((injector) => TransactionListService(
        transactionFactory: injector.getDependency<TransactionFactory>(),
        apiConsumerService: injector.getDependency<ApiConsumerService>()
    ));
  }
}