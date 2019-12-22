import 'dart:typed_data';

import 'package:base58check/base58.dart';
import 'package:ercoin_wallet/model/base/address.dart';

class Addresses {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static Address fromString(String publicKey) =>
      Address(bytes: Uint8List.fromList(_base58codec.decode(publicKey)));

  static String encode(Uint8List bytes) => _base58codec.encode(bytes);
}