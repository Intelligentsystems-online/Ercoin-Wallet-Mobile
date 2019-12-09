import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_decode_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transaction_encode_service.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class TransactionFactory
{
  final TransactionDecodeService transactionDecodeService;
  final TransactionEncodeService transactionEncodeService;

  TransactionFactory({this.transactionDecodeService, this.transactionEncodeService});

  Transaction createFromBase64(String transactionBase64) {
    var transactionBytes = base64.decode(transactionBase64);
    var messageLength = transactionDecodeService.obtainMessageLength(transactionBytes);

    return Transaction(
        transactionDecodeService.obtainReceiverAddress(transactionBytes),
        transactionDecodeService.obtainSenderAddress(transactionBytes, messageLength),
        transactionDecodeService.obtainTransactionValue(transactionBytes),
        transactionDecodeService.obtainMessage(transactionBytes, messageLength),
        transactionDecodeService.obtainTimestampValue(transactionBytes)
    );
  }

  Future<Uint8List> createSignedTransactionBytesFrom(String receiverAddress, String senderAddress, int transactionValue, String transactionMessage, String publicKey, String privateKey) async {
    var timestamp = (new DateTime.now().millisecondsSinceEpoch  / 1000).round();

    var timestampBytes = transactionEncodeService.encodeTimestamp(timestamp);
    var receiverAddressBytes = transactionEncodeService.encodeReceiverAddress(receiverAddress);
    var transactionValueBytes = transactionEncodeService.encodeTransactionValue(transactionValue);
    var messageLengthBytes = transactionEncodeService.encodeMessageLength(transactionMessage.length);
    var senderAddressBytes = transactionEncodeService.encodeSenderAddress(publicKey);
    var messageBytes = transactionEncodeService.encodeMessage(transactionMessage);

    List<int> transactionBytes = List.from([0]);
    transactionBytes.addAll(timestampBytes);
    transactionBytes.addAll(receiverAddressBytes);
    transactionBytes.addAll(transactionValueBytes);
    transactionBytes.addAll(messageLengthBytes);
    transactionBytes.addAll(messageBytes);
    transactionBytes.addAll([1]);
    transactionBytes.addAll(senderAddressBytes);

    Uint8List ed25519Signature = await CryptoSign.signBytes(Uint8List.fromList(transactionBytes), Uint8List.fromList(hex.decode(privateKey)));

    transactionBytes.addAll(ed25519Signature);

    return Uint8List.fromList(transactionBytes);
  }
}