import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';

//TODO(Create generic response model containing response status [SUCCESS, FAILURE] and optionally response value)
class ApiConsumerService
{
  final uriFactory = UriFactory(); //TODO(DI)

  Future<bool> makeTransaction(String transactionHex) => http
      .get(uriFactory.makeTransactionUriFor(transactionHex))
      .then((response) => true);

  Future<String> fetchAccountDataBase64For(String address) async {
    final response = await http.get(uriFactory.accountDataUriFor(address));

    return jsonDecode(response.body)['result']['response']['value'] as String;
  }

  Future<List<String>> fetchOutboundTransactionBase64ListFor(String address) async {
    final response = await http.get(uriFactory.outboundTransactionsUriFor(address));

    return _obtainTransactionBase64ListFrom(response.body);
  }

  Future<List<String>> fetchIncomingTransactionBase64ListFor(String address) async {
    final response = await http.get(uriFactory.incomingTransactionsUriFor(address));

    return _obtainTransactionBase64ListFrom(response.body);
  }

  List<String> _obtainTransactionBase64ListFrom(String responseBody) {
    List<dynamic> transactions = jsonDecode(responseBody)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }
}