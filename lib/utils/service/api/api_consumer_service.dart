import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/model/api_response.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/utils/service/api/code_mapper_util.dart';
import 'package:http/http.dart' as http;

import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';

//TODO(DI)
class ApiConsumerService {
  final CodeMapperUtil codeMapperUtil;
  final UriFactory uriFactory;

  ApiConsumerService({this.codeMapperUtil, this.uriFactory});

  Future<ApiResponseStatus> makeTransaction(String transactionHex) => http
      .get(uriFactory.createTransferUri(transactionHex))
      .then((response) => codeMapperUtil.genericCodeToStatus(_obtainTransferResponseCode(response.body)));

  int _obtainTransferResponseCode(String response) =>
      jsonDecode(response)['result']['code'] as int;

  Future<ApiResponse<String>> fetchAccountDataBase64For(String address) async {
    final response = await http.get(uriFactory.createAccountDataUri(address));
    final jsonResponse = jsonDecode(response.body)['result']['response'];
    final responseCode = jsonResponse['code'] as int;
    final responseStatus = codeMapperUtil.accountCodeToStatus(responseCode);

    if(responseStatus == ApiResponseStatus.SUCCESS)
      return ApiResponse(ApiResponseStatus.SUCCESS, jsonResponse['value'] as String);
    else  if(responseStatus == ApiResponseStatus.ACCOUNT_NOT_FOUND)
      return ApiResponse(ApiResponseStatus.ACCOUNT_NOT_FOUND, null);
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
}