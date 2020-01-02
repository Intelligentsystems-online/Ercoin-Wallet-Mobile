import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';

// TODO(Refactor)
class TransferDataDecodingService
{
  Uint8List convertTransferHexToBytes(String transactionHex) => hex.decode(transactionHex);

  Address obtainToAddress(Uint8List transferBytes) => Address(bytes: _obtainToAddressBytes(transferBytes));

  DateTime obtainTimestamp(Uint8List transferBytes) {
    ByteBuffer buffer = _obtainTimestampBytes(transferBytes).buffer;
    return DateTime.fromMillisecondsSinceEpoch(ByteData.view(buffer).getInt32(0) * 1000);
  }

  CoinsAmount obtainCoinsAmount(Uint8List transferBytes) {
    ByteBuffer buffer = _obtainCoinsAmountBytes(transferBytes).buffer;
    return CoinsAmount.ofMicroErcoin(ByteData.view(buffer).getInt64(0));
  }

  int obtainMessageLength(Uint8List transferBytes) => transferBytes.elementAt(45);

  String obtainMessage(Uint8List transferBytes, int messageLength) =>
      messageLength == 0 ? "" : utf8.decode(_obtainMessageBytes(transferBytes, messageLength));

  Address obtainFromAddress(Uint8List transferBytes, int messageLength) =>
      Address(bytes: _obtainFromAddressBytes(transferBytes, messageLength));

  Uint8List _obtainTimestampBytes(Uint8List transferBytes) => transferBytes.sublist(1, 5);

  Uint8List _obtainToAddressBytes(Uint8List transferBytes) => transferBytes.sublist(5, 37);

  Uint8List _obtainCoinsAmountBytes(Uint8List transferBytes) => transferBytes.sublist(37, 45);

  Uint8List _obtainMessageBytes(Uint8List transferBytes, int messageLength) {
    if(messageLength == 0)
      return Uint8List(0);
    else if(messageLength == 1)
      return Uint8List.fromList([transferBytes.elementAt(46)]);
    else
      return transferBytes.sublist(46, 46 + messageLength);
  }

  //TODO establishment: one public key always used to sign.
  Uint8List _obtainFromAddressBytes(Uint8List transferBytes, int messageLength) {
    if(messageLength == 0)
      return transferBytes.sublist(47, 79); // 40, 71
    else if(messageLength == 1)
      return transferBytes.sublist(48, 80); // 40, 72
    else
      return transferBytes.sublist(47 + messageLength, 79 + messageLength);
  }
}
