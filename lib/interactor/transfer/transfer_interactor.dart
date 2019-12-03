import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/interactor/transfer/send_transfer_error.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/utils/TransactionEncoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

//TODO(DI)
class TransferInteractor {
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _transactionEncoder = TransactionEncoder();
  final _accountRepository = AccountRepository();
  final _apiConsumer = ApiConsumer();

  Future<SendTransferError> sendTransfer(String destinationAddress, String message, double amount) async {
    final activeAccountPk = await _sharedPreferencesUtil.getSharedPreference('active_account');
    final activeAccount = await _accountRepository.findByPublicKey(activeAccountPk);

    final timestamp = (new DateTime.now().millisecondsSinceEpoch  / 1000).round();

    final timestampBytes = _transactionEncoder.encodeTimestamp(timestamp);
    final receiverAddressBytes = _transactionEncoder.encodeReceiverAddress(destinationAddress);
    final transactionValueBytes = _transactionEncoder.encodeTransactionValue(toMicroErcoins(amount));
    final messageLengthBytes = _transactionEncoder.encodeMessageLength(message.length);
    final senderAddressBytes = _transactionEncoder.encodeSenderAddress(activeAccountPk);
    final messageBytes = _transactionEncoder.encodeMessage(message);

    List<int> transactionBytes = List.from([0]);
    transactionBytes.addAll(timestampBytes);
    transactionBytes.addAll(receiverAddressBytes);
    transactionBytes.addAll(transactionValueBytes);
    transactionBytes.addAll(messageLengthBytes);
    transactionBytes.addAll(messageBytes);
    transactionBytes.addAll([1]);
    transactionBytes.addAll(senderAddressBytes);

    Uint8List ed25519Signature = await _prepareSignature(transactionBytes, activeAccount.privateKey);

    transactionBytes.addAll(ed25519Signature);

    final transactionHex = _transactionEncoder.convertTransactionBytesToHex(Uint8List.fromList(transactionBytes));

    _apiConsumer.makeTransaction(transactionHex);

    return null;
  }

  int toMicroErcoins(double amount) => (amount*1000000).floor();

  Future<Uint8List> _prepareSignature(List<int> transactionBytes, String privateKey) =>
      CryptoSign.signBytes(Uint8List.fromList(transactionBytes), Uint8List.fromList(hex.decode(privateKey)));
}
