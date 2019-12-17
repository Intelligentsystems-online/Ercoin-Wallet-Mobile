import 'package:convert/convert.dart';
import 'package:ercoin_wallet/service/common/byte_converter_service.dart';

import 'dart:typed_data';

class TransferDataEncodingService
{
  final ByteConverterService _byteConverter;

  TransferDataEncodingService(this._byteConverter);

  String convertTransactionBytesToHex(Uint8List transactionBytes) => hex.encode(transactionBytes);

  Uint8List encodeTimestamp(int timestamp) => _byteConverter.convertIntToBytes(BigInt.from(timestamp), 4);

  Uint8List encodeTransactionValue(int transactionValue) => _byteConverter.convertIntToBytes(BigInt.from(transactionValue), 8);

  Uint8List encodeReceiverAddress(String receiverAddress) => hex.decode(receiverAddress);

  Uint8List encodeSenderAddress(String senderAddress) => hex.decode(senderAddress);

  Uint8List encodeMessageLength(int messageLength) => Uint8List.fromList([messageLength]);

  Uint8List encodeMessage(String message) => Uint8List.fromList(message.codeUnits);
}
