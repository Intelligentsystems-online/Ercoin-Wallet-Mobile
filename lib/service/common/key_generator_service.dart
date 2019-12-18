import 'dart:async';

import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class KeyGeneratorService {
  Future<LocalAccountKeys> generateAccountKeys() async =>
      LocalAccountKeys.ofKeyPair(await CryptoSign.generateKeyPair());
}
