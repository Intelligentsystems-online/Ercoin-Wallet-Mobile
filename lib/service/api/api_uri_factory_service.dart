
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/addresses.dart';

class ApiUriFactoryService {
  static final String _hostname = "testnet-node.ercoin.tech";
  static final String _fetchTransactionsEndpoint = "/tx_search";
  static final String _accountDataEndpoint = "/abci_query";
  static final String _makeTransactionEndpoint = "/broadcast_tx_sync";

  Uri createOutboundTransactionsUri(Address address) =>
      Uri.https(_hostname, _fetchTransactionsEndpoint, { "query" : _prepareOutboundTransactionsQueryValue(address) });

  Uri createIncomingTransactionsUri(Address address) =>
      Uri.https(_hostname, _fetchTransactionsEndpoint, { "query" : _prepareIncomingTransactionsQueryValue(address) });

  Uri createAccountDataUri(Address address) =>
      Uri.https(_hostname, _accountDataEndpoint, { "path" : "\"account\"", "data" : "0x" + _addressToHex(address)});

  Uri createTransferUri(String transferHex) =>
      Uri.https(_hostname, _makeTransactionEndpoint, { "tx" : "0x" + transferHex});

  String _prepareOutboundTransactionsQueryValue(Address address) =>
      "\"tx.from=" + "'" + base64.encode(Addresses.toBytes(address)) + "'\"";

  String _prepareIncomingTransactionsQueryValue(Address address) =>
      "\"tx.to=" + "'" + base64.encode(Addresses.toBytes(address)) + "'\"";

  String _addressToHex(Address address) => hex.encode(Addresses.toBytes(address));
}
