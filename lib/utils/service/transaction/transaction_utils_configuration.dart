import 'package:ercoin_wallet/model/TransactionFactory.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/common/byte_converter.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_decode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_encode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';
import 'package:injector/injector.dart';

class TransactionUtilsConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
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