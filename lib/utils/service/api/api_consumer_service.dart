import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/model/api_response.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:http/http.dart' as http;

import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';

class ApiConsumerService
{
  final uriFactory = UriFactory(); //TODO(DI)

  Future<bool> makeTransaction(String transactionHex) => http
      .get(uriFactory.createTransferUri(transactionHex))
      .then((response) => true);

  Future<ApiResponse<String>> fetchAccountDataBase64For(String address) async {
    final response = await http.get(uriFactory.createAccountDataUri(address));
    final jsonResponse = jsonDecode(response.body)['result']['response'];
    final responseCode = jsonResponse['code'] as int;
    final responseStatus = responseAccountCodeToStatus(responseCode);

    if(responseStatus == ApiResponseStatus.SUCCESS)
      return ApiResponse(ApiResponseStatus.SUCCESS, jsonResponse['value'] as String);
    else
      return ApiResponse(ApiResponseStatus.FAILURE, null);
  }

  Future<ApiResponse<List<String>>> fetchOutboundTransactionBase64ListFor(String address) async {
    final response = await http.get(uriFactory.createOutboundTransactionsUri(address));

    return ApiResponse(ApiResponseStatus.SUCCESS, _obtainTransactionBase64ListFrom(response.body));
  }

  Future<ApiResponse<List<String>>> fetchIncomingTransactionBase64ListFor(String address) async {
    final response = await http.get(uriFactory.createIncomingTransactionsUri(address));

    return ApiResponse(ApiResponseStatus.SUCCESS, _obtainTransactionBase64ListFrom(response.body));
  }

  List<String> _obtainTransactionBase64ListFrom(String responseBody) {
    List<dynamic> transactions = jsonDecode(responseBody)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }

  ApiResponseStatus responseAccountCodeToStatus(int responseCode) {
    if(responseCode == 0)
      return ApiResponseStatus.SUCCESS;
    else if(responseCode == 2)
      return ApiResponseStatus.ACCOUNT_NOT_FOUND;
    else
      return ApiResponseStatus.FAILURE;
  }
}