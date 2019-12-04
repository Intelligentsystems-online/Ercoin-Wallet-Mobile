import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';

class ApiConsumer
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

    List<dynamic> transactions = jsonDecode(response.body)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }

  Future<List<String>> fetchIncomingTransactionBase64ListFor(String address) async {
    final response = await http.get(uriFactory.incomingTransactionsUriFor(address));

    List<dynamic> transactions = jsonDecode(response.body)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }
}