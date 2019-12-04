import 'dart:async';

import 'package:flutter_sodium/flutter_sodium.dart';

class KeyGenerator
{
  Future<KeyPair> generateKeyPair() => CryptoSign.generateKeyPair();
}