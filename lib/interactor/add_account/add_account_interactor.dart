import 'dart:async';

import 'package:ercoin_wallet/utils/KeyGenerator.dart';

import 'package:flutter_sodium/flutter_sodium.dart';

class AddAccountInteractor {
  final _keyGenerator = KeyGenerator();

  Future<KeyPair> generateKeyPair() async => _keyGenerator
      .generateKeyPair();
}
