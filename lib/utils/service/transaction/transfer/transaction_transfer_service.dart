import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_encoder.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class TransactionTransferService {
  final _transactionEncoder = TransactionEncoder();
  final _accountRepository = AccountRepository();
  final _apiConsumer = ApiConsumer();

  Future<bool> executeTransactionTransfer(String senderAddress, String destinationAddress, String message, double amount) async {
    final senderAccount = await _accountRepository.findByPublicKey(senderAddress);
    final transactionBytes = _obtainTransactionBytesFor(senderAddress, destinationAddress, message, amount);
    final signedTransactionBytes = await _obtainSignedTransactionBytesFor(transactionBytes, senderAccount.privateKey);
    final signedTransactionHex = _convertToHex(signedTransactionBytes);

    return _apiConsumer.makeTransaction(signedTransactionHex);
  }

  String _convertToHex(List<int> signedTransactionBytes) =>
      _transactionEncoder.convertTransactionBytesToHex(Uint8List.fromList(signedTransactionBytes));

  Future<List<int>> _obtainSignedTransactionBytesFor(List<int> transactionBytes, String privateKey) async {
    final ed25519Signature = await _prepareSignature(transactionBytes, privateKey);

    transactionBytes.addAll(ed25519Signature);

    return transactionBytes;
  }

  List<int> _obtainTransactionBytesFor(String senderAddress, String destinationAddress, String message, double amount) {
    final timestamp = (new DateTime.now().millisecondsSinceEpoch  / 1000).round();

    final timestampBytes = _transactionEncoder.encodeTimestamp(timestamp);
    final receiverAddressBytes = _transactionEncoder.encodeReceiverAddress(destinationAddress);
    final transactionValueBytes = _transactionEncoder.encodeTransactionValue(_toMicroErcoins(amount));
    final messageLengthBytes = _transactionEncoder.encodeMessageLength(message.length);
    final senderAddressBytes = _transactionEncoder.encodeSenderAddress(senderAddress);
    final messageBytes = _transactionEncoder.encodeMessage(message);

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