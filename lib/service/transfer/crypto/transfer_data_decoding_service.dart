import 'dart:typed_data';

import 'package:convert/convert.dart';

// TODO(Refactor)
class TransferDataDecodingService
{
  Uint8List convertTransactionHexToBytes(String transactionHex) => hex.decode(transactionHex);

  String obtainReceiverAddress(Uint8List transactionBytes) => hex.encode(_receiverAddressBytesFrom(transactionBytes));

  int obtainTimestampValue(Uint8List transactionBytes) {
    ByteBuffer buffer = _timestampBytesFrom(transactionBytes).buffer;

    return ByteData
        .view(buffer)
        .getInt32(0);
  }

  int obtainTransactionValue(Uint8List transactionBytes) {
    ByteBuffer buffer = _transactionValueBytesFrom(transactionBytes).buffer;

    return ByteData
        .view(buffer)
        .getInt64(0);
  }

  int obtainMessageLength(Uint8List transactionBytes) => transactionBytes.elementAt(45);

  String obtainMessage(Uint8List transactionBytes, int messageLength) =>
      messageLength == 0 ? "" : String.fromCharCodes(_messageBytesFrom(transactionBytes, messageLength));

  String obtainSenderAddress(Uint8List transactionBytes, int messageLength) => hex.encode(_senderAddressBytesFrom(transactionBytes, messageLength));

  Uint8List _timestampBytesFrom(Uint8List transactionBytes) => transactionBytes.sublist(1, 5);

  Uint8List _receiverAddressBytesFrom(Uint8List transactionBytes) => transactionBytes.sublist(5, 37);

  Uint8List _transactionValueBytesFrom(Uint8List transactionBytes) => transactionBytes.sublist(37, 45);

  Uint8List _messageBytesFrom(Uint8List transactionBytes, int messageLength) {
    if(messageLength == 0)
      return Uint8List(0);
    else if(messageLength == 1)
      return Uint8List.fromList([transactionBytes.elementAt(46)]);
    else
      return transactionBytes.sublist(46, 46 + messageLength);
  }

  //TODO establishment: one public key always used to sign.
  Uint8List _senderAddressBytesFrom(Uint8List transactionBytes, int messageLength) {
    if(messageLength == 0)
      return transactionBytes.sublist(47, 79); // 40, 71
    else if(messageLength == 1)
      return transactionBytes.sublist(48, 80); // 40, 72
    else
      return transactionBytes.sublist(47 + messageLength, 79 + messageLength);
  }
}
