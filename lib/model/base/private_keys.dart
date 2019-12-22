import 'dart:typed_data';

import 'package:base58check/base58.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';

class PrivateKeys {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static PrivateKey fromString(String privateKey) =>
      PrivateKey(bytes: Uint8List.fromList(_base58codec.decode(privateKey)));

  static String encode(Uint8List bytes) => _base58codec.encode(bytes);
}