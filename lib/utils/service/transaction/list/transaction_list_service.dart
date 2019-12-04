import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/TransactionFactory.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';

//TODO(DI)
class TransactionListService {
  final _transactionFactory = TransactionFactory();
  final _apiConsumer = ApiConsumerService();

  Future<List<Transaction>> obtainOutboundTransactionsFor(String address) async {
    final transactionsBase64 = await _apiConsumer.fetchOutboundTransactionBase64ListFor(address);

    return _obtainTransactionsFrom(transactionsBase64);
  }

  Future<List<Transaction>> obtainIncomingTransactionsFor(String address) async {
    final transactionsBase64 = await _apiConsumer.fetchIncomingTransactionBase64ListFor(address);

    return _obtainTransactionsFrom(transactionsBase64);
  }

  Future<List<Transaction>> obtainTransactionsFor(String address) async {
    final incomingTransactions = obtainIncomingTransactionsFor(address);
    final outboundTransactions = obtainOutboundTransactionsFor(address);

    final transactionSets = await Future.wait([incomingTransactions, outboundTransactions]);

    return transactionSets[0] + transactionSets[1];
  }

  List<Transaction> _obtainTransactionsFrom(List<String> transactionsBase64) => transactionsBase64
      .map((trxBase64) => _transactionFactory.createFromBase64(trxBase64))
      .toList();
}