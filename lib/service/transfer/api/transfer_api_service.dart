import 'dart:convert';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/api/api_response.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/transfer/transfer_data.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_data_decoding_service.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_signing_service.dart';

class TransferApiService {
  static final _invalidPageNumber = -1;

  final ApiConsumerService _apiConsumerService;
  final TransferDataDecodingService _decodingService;
  final TransferSigningService _signingService;

  const TransferApiService(
      this._apiConsumerService,
      this._decodingService,
      this._signingService,
  );

  Future<int> fetchInTransfersLastPageNumber(Address address) async {
    final response = await _apiConsumerService.fetchInTransfersLastPageNumber(address, _invalidPageNumber);

    return _extractLastPageNumber(response.body);
  }

  Future<int> fetchOutTransfersLastPageNumber(Address address) async {
    final response = await _apiConsumerService.fetchOutTransfersLastPageNumber(address, _invalidPageNumber);

    return _extractLastPageNumber(response.body);
  }

  int _extractLastPageNumber(String body) {
    final data = jsonDecode(body)['error']['data'];
    final startIndex = data.indexOf('[');
    final endIndex = data.indexOf(']');
    final lastPageNumber = data.substring(startIndex + 4, endIndex);

    return int.parse(lastPageNumber);
  }

  Future<List<TransferData>> obtainInTransferDataList(Address address, int pageNumber) async =>
    _decodeTransferDataList(await _apiConsumerService.fetchIncomingTransactionBase64ListFor(address, pageNumber));

  Future<List<TransferData>> obtainOutTransferDataList(Address address, int pageNumber) async =>
    _decodeTransferDataList(await _apiConsumerService.fetchOutboundTransactionBase64ListFor(address, pageNumber));

  Future<ApiResponseStatus> executeTransfer(
      Address destination,
      LocalAccount sender,
      String message,
      CoinsAmount amount,
  ) async {
    final signedTransferHex = await _signingService.createSignedTransferHex(destination, sender, message, amount);
    return await _apiConsumerService.makeTransaction(signedTransferHex);
  }

  List<TransferData> _decodeTransferDataList(ApiResponse<List<String>> apiResponse) {
    if(apiResponse.status == ApiResponseStatus.SUCCESS)
      return apiResponse
          .response
          .map((dataBase64) => _decodeTransferData(dataBase64))
          .toList();
    else
      return [];
  }

  TransferData _decodeTransferData(String transactionBase64) {
    var transactionBytes = base64.decode(transactionBase64);
    var messageLength = _decodingService.obtainMessageLength(transactionBytes);

    return TransferData(
      amount: _decodingService.obtainCoinsAmount(transactionBytes),
      from: _decodingService.obtainFromAddress(transactionBytes, messageLength),
      to: _decodingService.obtainToAddress(transactionBytes),
      message: _decodingService.obtainMessage(transactionBytes, messageLength),
      timestamp: _decodingService.obtainTimestamp(transactionBytes),
    );
  }
}
