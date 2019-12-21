import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/const_values/api_const_values.dart';
import 'package:ercoin_wallet/model/api/api_health_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/api/api_response.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/service/api/api_response_status_decoder_service.dart';
import 'package:ercoin_wallet/service/api/api_uri_factory_service.dart';
import 'package:http/http.dart' as http;

class ApiConsumerService {
  final ApiResponseStatusDecoderService _statusDecoderService;
  final ApiUriFactoryService _uriFactoryService;

  ApiConsumerService(this._statusDecoderService, this._uriFactoryService);

  Future<ApiHealthStatus> healthCheck(String uri) async {
    try {
      final response = await http.get("$uri/$healthEndpoint");
      return jsonDecode(response.body)
          .containsKey("jsonrpc") ? ApiHealthStatus.NODE_AVAILABLE : ApiHealthStatus.NODE_NOT_AVAILABLE;
    } catch (_) {
      return ApiHealthStatus.NODE_NOT_AVAILABLE;
    }
  }

  Future<ApiResponseStatus> makeTransaction(String transactionHex) async {
    final response = await http.get(await _uriFactoryService.createTransferUri(transactionHex));

    return _statusDecoderService.transferCodeToStatus(_obtainTransferResponseCode(response.body));
  }

  Future<ApiResponse<String>> fetchAccountDataBase64For(Address address) async {
    final response = await http.get(await _uriFactoryService.createAccountDataUri(address));
    final jsonResponse = jsonDecode(response.body)['result']['response'];
    final responseCode = jsonResponse['code'] as int;
    final responseStatus = _statusDecoderService.accountCodeToStatus(responseCode);

    if(responseStatus == ApiResponseStatus.SUCCESS)
      return ApiResponse(ApiResponseStatus.SUCCESS, jsonResponse['value'] as String);
    else  if(responseStatus == ApiResponseStatus.ACCOUNT_NOT_FOUND)
      return ApiResponse(ApiResponseStatus.ACCOUNT_NOT_FOUND, null);
    else
      return ApiResponse(ApiResponseStatus.GENERIC_ERROR, null);
  }

  Future<ApiResponse<List<String>>> fetchOutboundTransactionBase64ListFor(Address address) async {
    final response = await http.get(await _uriFactoryService.createOutboundTransactionsUri(address));

    return ApiResponse(ApiResponseStatus.SUCCESS, _obtainTransactionBase64ListFrom(response.body));
  }

  Future<ApiResponse<List<String>>> fetchIncomingTransactionBase64ListFor(Address address) async {
    final response = await http.get(await _uriFactoryService.createIncomingTransactionsUri(address));

    return ApiResponse(ApiResponseStatus.SUCCESS, _obtainTransactionBase64ListFrom(response.body));
  }
  
  int _obtainTransferResponseCode(String response) =>
      jsonDecode(response)['result']['code'] as int;

  List<String> _obtainTransactionBase64ListFrom(String responseBody) {
    List<dynamic> transactions = jsonDecode(responseBody)['result']['txs'];

    return transactions
        .map((transaction) => transaction['tx'] as String)
        .toList();
  }
}
