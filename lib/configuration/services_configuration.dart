import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_repository.dart';
import 'package:ercoin_wallet/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/service/api/api_response_status_decoder_service.dart';
import 'package:ercoin_wallet/service/api/api_uri_factory_service.dart';
import 'package:ercoin_wallet/service/common/byte_converter_service.dart';
import 'package:ercoin_wallet/service/common/key_generator_service.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/service/database/database_service.dart';
import 'package:ercoin_wallet/service/file/json_file_service.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/api/local_account_api_service.dart';
import 'package:ercoin_wallet/service/local_account/api/local_account_details_decoding_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';
import 'package:ercoin_wallet/service/settings/settings_service.dart';
import 'package:ercoin_wallet/service/transfer/api/transfer_api_service.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_data_decoding_service.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_data_encoding_service.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_signing_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_list_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';
import 'package:injector/injector.dart';
import 'package:sqflite/sqlite_api.dart';

class ServicesConfiguration {
  static configure(Injector injector) {
    _configureApi(injector);
    _configureCommon(injector);
    _configureDatabase(injector);
    _configureFile(injector);
    _configureLocalAccount(injector);
    _configureNamedAddress(injector);
    _configureSettings(injector);
    _configureTransfer(injector);
  }

  static initialize(Injector injector) async {
    await injector.getDependency<DatabaseService>().initialize();
  }

  static _configureApi(Injector injector) {
    injector.registerSingleton<ApiResponseStatusDecoderService>((_) => ApiResponseStatusDecoderService());
    injector.registerSingleton<ApiUriFactoryService>((injector) => ApiUriFactoryService(
      injector.getDependency<SharedPreferencesService>()
    ));
    injector.registerSingleton<ApiConsumerService>((injector) => ApiConsumerService(
        injector.getDependency<ApiResponseStatusDecoderService>(),
        injector.getDependency<ApiUriFactoryService>(),
    ));
  }

  static _configureCommon(Injector injector) {
    injector.registerSingleton<ByteConverterService>((_) => ByteConverterService());
    injector.registerSingleton<KeyGeneratorService>((_) => KeyGeneratorService());
    injector.registerSingleton<KeysFormatValidatorService>((_) => KeysFormatValidatorService());
    injector.registerSingleton<SharedPreferencesService>((_) => SharedPreferencesService());
  }

  static _configureFile(Injector injector) {
    injector.registerSingleton<JsonFileService>((_) => JsonFileService());
  }

  static _configureDatabase(Injector injector) {
    injector.registerSingleton<DatabaseService>((_) => DatabaseService());
    injector.registerSingleton<Database>((injector) => injector.getDependency<DatabaseService>().obtainDatabase());
  }

  static _configureLocalAccount(Injector injector) {
    injector.registerSingleton<LocalAccountDetailsDecodingService>((_) => LocalAccountDetailsDecodingService());
    injector.registerSingleton<LocalAccountApiService>((injector) => LocalAccountApiService(
      injector.getDependency<ApiConsumerService>(),
      injector.getDependency<LocalAccountDetailsDecodingService>(),
    ));
    injector.registerSingleton<LocalAccountService>((injector) => LocalAccountService(
      injector.getDependency<LocalAccountRepository>(),
      injector.getDependency<LocalAccountDetailsCacheService>(),
    ));
    injector.registerSingleton<ActiveLocalAccountService>((injector) => ActiveLocalAccountService(
        injector.getDependency<LocalAccountService>(),
        injector.getDependency<LocalAccountDetailsCacheService>(),
        injector.getDependency<ActiveAccountTransferListCacheService>(),
        injector.getDependency<SharedPreferencesService>(),
    ));
    injector.registerSingleton<LocalAccountDetailsCacheService>((injector) => LocalAccountDetailsCacheService(
      injector.getDependency<LocalAccountRepository>(),
      injector.getDependency<LocalAccountApiService>()
    ));
  }

  static _configureNamedAddress(Injector injector) {
    injector.registerSingleton<NamedAddressService>((injector) => NamedAddressService(
        injector.getDependency<NamedAddressRepository>(),
    ));
  }

  static _configureSettings(Injector injector) {
    injector.registerSingleton<SettingsService>((injector) => SettingsService(
      injector.getDependency<SharedPreferencesService>()
    ));
  }

  static _configureTransfer(Injector injector) {
    injector.registerSingleton<TransferDataDecodingService>((_) => TransferDataDecodingService());
    injector.registerSingleton<TransferDataEncodingService>((injector) => TransferDataEncodingService(
      injector.getDependency<ByteConverterService>(),
    ));
    injector.registerSingleton<TransferSigningService>((injector) => TransferSigningService(
      injector.getDependency<TransferDataEncodingService>(),
    ));
    injector.registerSingleton<TransferApiService>((injector) => TransferApiService(
      injector.getDependency<ApiConsumerService>(),
      injector.getDependency<TransferDataDecodingService>(),
      injector.getDependency<TransferSigningService>(),
    ));
    injector.registerSingleton<TransferService>((injector) => TransferService(
        injector.getDependency<TransferApiService>(),
        injector.getDependency<ActiveLocalAccountService>(),
        injector.getDependency<LocalAccountDetailsCacheService>(),
        injector.getDependency<ActiveAccountTransferListCacheService>()
    ));
    injector.registerSingleton<TransferListService>((injector) => TransferListService(
      injector.getDependency<TransferApiService>(),
      injector.getDependency<NamedAddressService>()
    ));
    injector.registerSingleton<ActiveAccountTransferListCacheService>((injector) => ActiveAccountTransferListCacheService(
      injector.getDependency<TransferListService>()
    ));
  }
}
