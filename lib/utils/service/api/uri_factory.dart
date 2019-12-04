
import 'dart:convert';

import 'package:convert/convert.dart';

class UriFactory {
  static final String _hostname = "testnet-node.ercoin.tech";
  static final String _fetchTransactionsEndpoint = "/tx_search";
  static final String _accountDataEndpoint = "/abci_query";
  static final String _makeTransactionEndpoint = "/broadcast_tx_sync";

  Uri createOutboundTransactionsUri(String address) =>
      new Uri.https(_hostname, _fetchTransactionsEndpoint, { "query" : _prepareOutboundTransactionsQueryValue(address) });

  Uri createIncomingTransactionsUri(String address) =>
      new Uri.https(_hostname, _fetchTransactionsEndpoint, { "query" : _prepareIncomingTransactionsQueryValue(address) });

  Uri createAccountDataUri(String address) =>
      new Uri.https(_hostname, _accountDataEndpoint, { "path" : "\"account\"", "data" : "0x" + address});

  Uri createTransferUri(String transactionHex) =>
      new Uri.https(_hostname, _makeTransactionEndpoint, { "tx" : "0x" + transactionHex});

  String _prepareOutboundTransactionsQueryValue(String address) =>
      "\"tx.from=" + "'" + base64.encode(hex.decode(address)) + "'\"";

  String _prepareIncomingTransactionsQueryValue(String address) =>
      "\"tx.to=" + "'" + base64.encode(hex.decode(address)) + "'\"";
}