import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

class ApiConsumer
{
  static final String _hostname = "testnet-node.ercoin.tech";
  static final String _fetchTransactionsEndpoint = "/tx_search";
  static final String _accountDataEndpoint = "/abci_query";
  static final String _makeTransactionEndpoint = "/broadcast_tx_sync";

  Future<bool> makeTransaction(String transactionHex) => http
      .get(_prepareMakeTransactionUriFor(transactionHex))
      .then((response) => true);

  Future<String> fetchAccountDataBase64For(String address) async {
    final response = await http.get(_prepareAccountDataUriFor(address));

    return jsonDecode(response.body)['result']['response']['value'] as String;
  }

  Future<List<String>> fetchOutboundTransactionBase64ListFor(String address) async {
    final response = await http.get(_prepareOutboundTransactionsUriFor(address));

    List<dynamic> transactions = jsonDecode(response.body)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }

  Future<List<String>> fetchIncomingTransactionBase64ListFor(String address) async {
    final response = await http.get(_prepareIncomingTransactionsUriFor(address));

    List<dynamic> transactions = jsonDecode(response.body)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }

  Uri _prepareOutboundTransactionsUriFor(String address) =>
      new Uri.https(_hostname, _fetchTransactionsEndpoint, { "query" : _prepareOutboundTransactionsQueryValue(address) });

  Uri _prepareIncomingTransactionsUriFor(String address) =>
      new Uri.https(_hostname, _fetchTransactionsEndpoint, { "query" : _prepareIncomingTransactionsQueryValue(address) });

  String _prepareOutboundTransactionsQueryValue(String address) =>
      "\"tx.from=" + "'" + base64.encode(hex.decode(address)) + "'\"";

  String _prepareIncomingTransactionsQueryValue(String address) =>
      "\"tx.to=" + "'" + base64.encode(hex.decode(address)) + "'\"";

  Uri _prepareAccountDataUriFor(String address) =>
      new Uri.https(_hostname, _accountDataEndpoint, { "path" : "\"account\"", "data" : "0x" + address});

  Uri _prepareMakeTransactionUriFor(String transactionHex) =>
      new Uri.https(_hostname, _makeTransactionEndpoint, { "tx" : "0x" + transactionHex});
}