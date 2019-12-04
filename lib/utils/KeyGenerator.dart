import 'dart:async';

import 'package:flutter_sodium/flutter_sodium.dart';

//TODO(Remove after removing unused view Screens)
class KeyGenerator
{
  Future<KeyPair> generateKeyPair() => CryptoSign.generateKeyPair();
}