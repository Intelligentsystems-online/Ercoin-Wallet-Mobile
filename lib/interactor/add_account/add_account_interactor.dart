import 'dart:async';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/utils/KeyGenerator.dart';

//TODO(DI)
class AddAccountInteractor {
  final _keyGenerator = KeyGenerator();

  Future<AccountKeys> generateAccountKeys() async {
    final keyPair = await _keyGenerator.generateKeyPair();
    return AccountKeys(hex.encode(keyPair.publicKey), hex.encode(keyPair.secretKey));
  }
}
