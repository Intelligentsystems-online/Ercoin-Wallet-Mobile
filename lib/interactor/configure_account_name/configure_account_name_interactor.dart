import 'dart:async';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class ConfigureAccountNameInteractor {
  final _accountRepository = AccountRepository();
  
  Future<void> addAccount(KeyPair keyPair, String name) async => _accountRepository
      .createAccount(_prepareAccountFor(keyPair, name));

  _prepareAccountFor(KeyPair keyPair, String name) => Account(
    hex.encode(keyPair.publicKey),
    hex.encode(keyPair.secretKey),
    name);
}
