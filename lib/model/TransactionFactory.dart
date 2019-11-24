import 'dart:convert';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/TransactionDecoder.dart';

class TransactionFactory
{
  final _transactionDecoder = TransactionDecoder();

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
}