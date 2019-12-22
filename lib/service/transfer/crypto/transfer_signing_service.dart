import 'dart:typed_data';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/service/transfer/crypto/transfer_data_encoding_service.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class TransferSigningService {
  final TransferDataEncodingService _encodingService;

  const TransferSigningService(this._encodingService);

  Future<String> createSignedTransferHex(
      Address destination, 
      LocalAccount sender,
      String message, 
      CoinsAmount amount,
  ) async {
    List<int> transactionBytes = List.from([0]);
    transactionBytes.addAll(_encodingService.encodeTimestamp(DateTime.now()));
    transactionBytes.addAll(_encodingService.encodeToAddress(destination));
    transactionBytes.addAll(_encodingService.encodeCoinsAmount(amount));
    transactionBytes.addAll(_encodingService.encodeMessageLength(message.length));
    transactionBytes.addAll(_encodingService.encodeMessage(message));
    transactionBytes.addAll([1]);
    transactionBytes.addAll(_encodingService.encodeFromAddress(sender.namedAddress.address));

    return _convertToHex(await _signTransactionBytes(transactionBytes, sender.privateKey));
  }

  String _convertToHex(List<int> signedTransactionBytes) =>
      _encodingService.convertTransferBytesToHex(Uint8List.fromList(signedTransactionBytes));

  Future<List<int>> _signTransactionBytes(List<int> transactionBytes, PrivateKey privateKey) async {
    final ed25519Signature = await _createSignature(transactionBytes, privateKey);
    transactionBytes.addAll(ed25519Signature);
    return transactionBytes;
  }

  Future<Uint8List> _createSignature(List<int> transactionBytes, PrivateKey privateKey) async =>
      await CryptoSign.signBytes(
          Uint8List.fromList(transactionBytes),
          privateKey.bytes
      );
}
