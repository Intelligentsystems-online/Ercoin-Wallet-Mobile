import 'dart:typed_data';

import 'package:ercoin_wallet/utils/service/common/byte_converter_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer_data_encoding_service.dart';
import 'package:test/test.dart';

void main() {
  final _transactionBytes = [0, 93, 212, 28, 135, 47, 217, 1, 84, 104, 143, 211, 240, 84, 126, 170, 219, 43, 115, 111, 236, 249, 174, 75, 34, 214, 177, 216, 206, 160, 198, 135, 163, 19, 6, 171, 229, 0, 0, 0, 0, 0, 15, 66, 64, 3, 102, 111, 111, 1, 11, 93, 83, 231, 111, 86, 254, 46, 240, 171, 19, 59, 140, 80, 18, 180, 127, 191, 110, 55, 25, 121, 76, 230, 220, 74, 230, 131, 198, 152, 35, 199, 225, 95, 15, 12, 80, 65, 85, 123, 36, 130, 197, 206, 79, 234, 59, 236, 246, 8, 127, 103, 78, 185, 58, 225, 216, 11, 226, 138, 175, 227, 111, 121, 179, 251, 52, 175, 31, 95, 249, 132, 170, 234, 125, 190, 37, 228, 122, 198, 6, 205, 248, 73, 190, 16, 189, 237, 79, 124, 244, 54, 198, 1, 136, 14];
  final _transactionHex = "005dd41c872fd90154688fd3f0547eaadb2b736fecf9ae4b22d6b1d8cea0c687a31306abe500000000000f424003666f6f010b5d53e76f56fe2ef0ab133b8c5012b47fbf6e3719794ce6dc4ae683c69823c7e15f0f0c5041557b2482c5ce4fea3becf6087f674eb93ae1d80be28aafe36f79b3fb34af1f5ff984aaea7dbe25e47ac606cdf849be10bded4f7cf436c601880e";

  final _senderAddressBytes = [11,93,83,231,111,86,254,46,240,171,19,59,140,80,18,180,127,191,110,55,25,121,76,230,220,74,230,131,198,152,35,199];
  final _transactionEncoder = TransactionEncodeService(ByteConverter());
  
  test('Should correctly encode timestamp', () {
    var timestampBytes = _transactionEncoder.encodeTimestamp(1574182023);

    expect(Uint8List.fromList([93,212,28,135]), timestampBytes);
  });
  
  test('Should correctly encode transaction value', () {
    var transactionValueBytes = _transactionEncoder.encodeTransactionValue(1000000);

    expect(Uint8List.fromList([0,0,0,0,0,15,66,64]), transactionValueBytes);
  });

  test('Should correctly encode message length', () {
    var messageLengthBytes = _transactionEncoder.encodeMessageLength(3);

    expect(Uint8List.fromList([3]), messageLengthBytes);
  });

  test('Should correctly encode message', () {
    var messageBytes = _transactionEncoder.encodeMessage("foo");
    
    expect(Uint8List.fromList([102,111,111]), messageBytes);
  });

  test('Should correctly encode sender address', () {
    var senderAddressBytes = _transactionEncoder.encodeSenderAddress("0b5d53e76f56fe2ef0ab133b8c5012b47fbf6e3719794ce6dc4ae683c69823c7");

    expect(_senderAddressBytes, senderAddressBytes);
  });

  test('Should correctly convert transaction bytes to hex', () {
    var encodedTransactionHex = _transactionEncoder.convertTransactionBytesToHex(Uint8List.fromList(_transactionBytes));

    expect(encodedTransactionHex, _transactionHex);
  });
}
