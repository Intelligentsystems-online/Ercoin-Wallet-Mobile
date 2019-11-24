import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/TransactionDecoder.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

import '../utils/TransactionEncoder.dart';

class TransactionFactory
{
  final _transactionDecoder = TransactionDecoder();
  final _transactionEncoder = TransactionEncoder();

  Transaction createFromBase64(String transactionBase64) {
    var transactionBytes = base64.decode(transactionBase64);
    var messageLength = _transactionDecoder.obtainMessageLength(transactionBytes);

    return Transaction(
        _transactionDecoder.obtainReceiverAddress(transactionBytes),
        _transactionDecoder.obtainSenderAddress(transactionBytes, messageLength),
        _transactionDecoder.obtainTransactionValue(transactionBytes),
        _transactionDecoder.obtainMessage(transactionBytes, messageLength),
        _transactionDecoder.obtainTimestampValue(transactionBytes)
    );
  }

  Future<Uint8List> createSignedTransactionBytesFrom(String receiverAddress, String senderAddress, int transactionValue, String transactionMessage, String publicKey, String privateKey) async {
    var timestamp = (new DateTime.now().millisecondsSinceEpoch  / 1000).round();

    var timestampBytes = _transactionEncoder.encodeTimestamp(timestamp);
    var receiverAddressBytes = _transactionEncoder.encodeReceiverAddress(receiverAddress);
    var transactionValueBytes = _transactionEncoder.encodeTransactionValue(transactionValue);
    var messageLengthBytes = _transactionEncoder.encodeMessageLength(transactionMessage.length);
    var senderAddressBytes = _transactionEncoder.encodeSenderAddress(publicKey);
    var messageBytes = _transactionEncoder.encodeMessage(transactionMessage);

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