import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/api_response.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_factory.dart';

class TransactionListService {
  final TransactionFactory transactionFactory;
  final ApiConsumerService apiConsumerService;

  TransactionListService({this.transactionFactory, this.apiConsumerService});

  Future<List<Transaction>> obtainOutboundTransactionsFor(String address) async {
    final apiResponse = await apiConsumerService.fetchOutboundTransactionBase64ListFor(address);

    return _obtainTransactionsFrom(apiResponse);
  }

  Future<List<Transaction>> obtainIncomingTransactionsFor(String address) async {
    final apiResponse = await apiConsumerService.fetchIncomingTransactionBase64ListFor(address);

    return _obtainTransactionsFrom(apiResponse);
  }

  Future<List<Transaction>> obtainTransactionsFor(String address) async {
    final incomingTransactions = obtainIncomingTransactionsFor(address);
    final outboundTransactions = obtainOutboundTransactionsFor(address);

    final transactionSets = await Future.wait([incomingTransactions, outboundTransactions]);

    return transactionSets[0] + transactionSets[1];
  }

  List<Transaction> _obtainTransactionsFrom(ApiResponse<List<String>> apiResponse) {
    if(apiResponse.status == ApiResponseStatus.SUCCESS)
      return apiResponse
          .response
          .map((trxBase64) => transactionFactory.createFromBase64(trxBase64))
          .toList();
    else
      return [];
  }
}