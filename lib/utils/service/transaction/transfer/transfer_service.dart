import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_encode_service.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class TransferService {
  final TransactionEncodeService transactionEncodeService;
  final AccountRepository accountRepository;
  final ApiConsumerService apiConsumerService;

  TransferService({this.transactionEncodeService, this.accountRepository, this.apiConsumerService});

  Future<ApiResponseStatus> executeTransfer(String senderAddress, String destinationAddress, String message, double amount) async {
    final senderAccount = await accountRepository.findByPublicKey(senderAddress);
    final transactionBytes = _obtainTransactionBytesFor(senderAddress, destinationAddress, message, amount);
    final signedTransactionBytes = await _obtainSignedTransactionBytesFor(transactionBytes, senderAccount.privateKey);
    final signedTransactionHex = _convertToHex(signedTransactionBytes);

    return apiConsumerService.makeTransaction(signedTransactionHex);
  }

  String _convertToHex(List<int> signedTransactionBytes) =>
      transactionEncodeService.convertTransactionBytesToHex(Uint8List.fromList(signedTransactionBytes));

  Future<List<int>> _obtainSignedTransactionBytesFor(List<int> transactionBytes, String privateKey) async {
    final ed25519Signature = await _prepareSignature(transactionBytes, privateKey);

    transactionBytes.addAll(ed25519Signature);

    return transactionBytes;
  }

  List<int> _obtainTransactionBytesFor(String senderAddress, String destinationAddress, String message, double amount) {
    final timestamp = (new DateTime.now().millisecondsSinceEpoch  / 1000).round();

    final timestampBytes = transactionEncodeService.encodeTimestamp(timestamp);
    final receiverAddressBytes = transactionEncodeService.encodeReceiverAddress(destinationAddress);
    final transactionValueBytes = transactionEncodeService.encodeTransactionValue(_toMicroErcoins(amount));
    final messageLengthBytes = transactionEncodeService.encodeMessageLength(message.length);
    final senderAddressBytes = transactionEncodeService.encodeSenderAddress(senderAddress);
    final messageBytes = transactionEncodeService.encodeMessage(message);

    List<int> transactionBytes = List.from([0]);
    transactionBytes.addAll(timestampBytes);
    transactionBytes.addAll(receiverAddressBytes);
    transactionBytes.addAll(transactionValueBytes);
    transactionBytes.addAll(messageLengthBytes);
    transactionBytes.addAll(messageBytes);
    transactionBytes.addAll([1]);
    transactionBytes.addAll(senderAddressBytes);

    return transactionBytes;
  }

  Future<Uint8List> _prepareSignature(List<int> transactionBytes, String privateKey) =>
      CryptoSign.signBytes(Uint8List.fromList(transactionBytes), Uint8List.fromList(hex.decode(privateKey)));

  int _toMicroErcoins(double amount) => (amount*1000000).floor();
}