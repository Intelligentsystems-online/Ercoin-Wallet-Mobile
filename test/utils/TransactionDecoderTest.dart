import 'dart:typed_data';

import 'package:ercoin_wallet/utils/service/transaction/transaction_decode_service.dart';
import 'package:test/test.dart';

void main() {
  final _messageLength = 3;

  final _transactionBytes = Uint8List.fromList([0, 93, 212, 28, 135, 47, 217, 1, 84, 104, 143, 211, 240, 84, 126, 170, 219, 43, 115, 111, 236, 249, 174, 75, 34, 214, 177, 216, 206, 160, 198, 135, 163, 19, 6, 171, 229, 0, 0, 0, 0, 0, 15, 66, 64, 3, 102, 111, 111, 1, 11, 93, 83, 231, 111, 86, 254, 46, 240, 171, 19, 59, 140, 80, 18, 180, 127, 191, 110, 55, 25, 121, 76, 230, 220, 74, 230, 131, 198, 152, 35, 199, 225, 95, 15, 12, 80, 65, 85, 123, 36, 130, 197, 206, 79, 234, 59, 236, 246, 8, 127, 103, 78, 185, 58, 225, 216, 11, 226, 138, 175, 227, 111, 121, 179, 251, 52, 175, 31, 95, 249, 132, 170, 234, 125, 190, 37, 228, 122, 198, 6, 205, 248, 73, 190, 16, 189, 237, 79, 124, 244, 54, 198, 1, 136, 14]);
  final _transactionDecoder = TransactionDecodeService();

  test('Should correctly obtain timestamp', () {
    var timestampValue = _transactionDecoder.obtainTimestampValue(_transactionBytes);

    expect(timestampValue, 1574182023);
  });

  test('Should correctly obtain transaction value', () {
    var transactionValue = _transactionDecoder.obtainTransactionValue(_transactionBytes);

    expect(transactionValue, 1000000);
  });

  test('Should correctly obtain message length', () {
    var messageLengthValue = _transactionDecoder.obtainMessageLength(_transactionBytes);

    expect(messageLengthValue, _messageLength);
  });

  test('Should correctly obtain message', () {
    var messageValue = _transactionDecoder.obtainMessage(_transactionBytes, _messageLength);

    expect(messageValue, "foo");
  });

  test('Should corretly obtain sender address', () {
    var senderAddressValue = _transactionDecoder.obtainSenderAddress(_transactionBytes, _messageLength);

    expect(senderAddressValue, "0b5d53e76f56fe2ef0ab133b8c5012b47fbf6e3719794ce6dc4ae683c69823c7");
  });
}