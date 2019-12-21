import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/const_values/api_const_values.dart';
import 'package:ercoin_wallet/const_values/shared_preferences_const_values.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/model/base/addresses.dart';

class ApiUriFactoryService {
  final SharedPreferencesService _sharedPreferencesService;

  ApiUriFactoryService(this._sharedPreferencesService);

  Future<Uri> createOutboundTransactionsUri(Address address) async =>
      Uri.https(await _obtainHostname(), fetchTransactionsEndpoint, { "query" : _prepareOutboundTransactionsQueryValue(address) });

  Future<Uri> createIncomingTransactionsUri(Address address) async =>
      Uri.https(await _obtainHostname(), fetchTransactionsEndpoint, { "query" : _prepareIncomingTransactionsQueryValue(address) });

  Future<Uri> createAccountDataUri(Address address) async =>
      Uri.https(await _obtainHostname(), accountDataEndpoint, { "path" : "\"account\"", "data" : "0x" + _addressToHex(address)});

  Future<Uri> createTransferUri(String transferHex) async =>
      Uri.https(await _obtainHostname(), makeTransactionEndpoint, { "tx" : "0x" + transferHex});

  String _prepareOutboundTransactionsQueryValue(Address address) =>
      "\"tx.from=" + "'" + base64.encode(Addresses.toBytes(address)) + "'\"";

  String _prepareIncomingTransactionsQueryValue(Address address) =>
      "\"tx.to=" + "'" + base64.encode(Addresses.toBytes(address)) + "'\"";

  Future<String> _obtainHostname() async {
    final nodeUri = await _sharedPreferencesService.getSharedPreference(nodeUriPreferenceKey);

    return nodeUri.isEmpty ? _extractHostnameFrom(defaultNodeUri) : _extractHostnameFrom(nodeUri);
  }

  String _extractHostnameFrom(String uri) => Uri.parse(uri).host;

  String _addressToHex(Address address) => hex.encode(Addresses.toBytes(address));
}
