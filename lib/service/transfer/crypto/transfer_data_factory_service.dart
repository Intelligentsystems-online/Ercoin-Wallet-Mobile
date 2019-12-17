import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/api/transfer_data.dart';
import 'package:ercoin_wallet/model/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account_data.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_data_decoding_service.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_data_encoding_service.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class TransferDataFactoryService {
  final TransferDataDecodingService _decodingService;
  final TransferDataEncodingService _encodingService;

  TransferDataFactoryService(this._decodingService, this._encodingService);

  TransferData createFromBase64(String transactionBase64) {
    var transactionBytes = base64.decode(transactionBase64);
    var messageLength = _decodingService.obtainMessageLength(transactionBytes);

    return TransferData(
        amount: CoinsAmount.ofMicroErcoin(_decodingService.obtainTransactionValue(transactionBytes)),
        from: Address(publicKey: _decodingService.obtainSenderAddress(transactionBytes, messageLength)),
        to: Address(publicKey: _decodingService.obtainReceiverAddress(transactionBytes)),
        message: _decodingService.obtainMessage(transactionBytes, messageLength),
        timestamp: DateTime.fromMillisecondsSinceEpoch(_decodingService.obtainTimestampValue(transactionBytes)),
    );
  }

  Future<Uint8List> createSignedTransactionBytesFrom(
      Address receiverAddress, Address senderAddress, CoinsAmount transactionValue,
      String transactionMessage, LocalAccountKeys keys,
  ) async {
    var timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).round();

    var timestampBytes = _encodingService.encodeTimestamp(timestamp);
    var receiverAddressBytes = _encodingService.encodeReceiverAddress(receiverAddress.publicKey);
    var transactionValueBytes = _encodingService.encodeTransactionValue(transactionValue.microErcoin);
    var messageLengthBytes = _encodingService.encodeMessageLength(transactionMessage.length);
    var senderAddressBytes = _encodingService.encodeSenderAddress(keys.address.publicKey);
    var messageBytes = _encodingService.encodeMessage(transactionMessage);

    List<int> transactionBytes = List.from([0]);
    transactionBytes.addAll(timestampBytes);
    transactionBytes.addAll(receiverAddressBytes);
    transactionBytes.addAll(transactionValueBytes);
    transactionBytes.addAll(messageLengthBytes);
    transactionBytes.addAll(messageBytes);
    transactionBytes.addAll([1]);
    transactionBytes.addAll(senderAddressBytes);

    Uint8List ed25519Signature =
        await CryptoSign.signBytes(
            Uint8List.fromList(transactionBytes),
            Uint8List.fromList(hex.decode(keys.privateKey.privateKey),
        ));

    transactionBytes.addAll(ed25519Signature);

    return Uint8List.fromList(transactionBytes);
  }
}
