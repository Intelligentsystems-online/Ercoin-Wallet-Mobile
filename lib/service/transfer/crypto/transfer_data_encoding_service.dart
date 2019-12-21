import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/addresses.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/service/common/byte_converter_service.dart';

import 'dart:typed_data';

class TransferDataEncodingService {
  final ByteConverterService _byteConverter;

  const TransferDataEncodingService(this._byteConverter);

  String convertTransferBytesToHex(Uint8List transferBytes) => hex.encode(transferBytes);

  Uint8List encodeTimestamp(DateTime timestamp) =>
      _byteConverter.convertIntToBytes(BigInt.from(timestamp.millisecondsSinceEpoch / 1000), 4);

  Uint8List encodeCoinsAmount(CoinsAmount value) =>
      _byteConverter.convertIntToBytes(BigInt.from(value.microErcoin), 8);

  Uint8List encodeToAddress(Address address) => Addresses.toBytes(address);

  Uint8List encodeFromAddress(Address address) => Addresses.toBytes(address);

  Uint8List encodeMessageLength(int messageLength) => Uint8List.fromList([messageLength]);

  Uint8List encodeMessage(String message) => Uint8List.fromList(message.codeUnits);
}
