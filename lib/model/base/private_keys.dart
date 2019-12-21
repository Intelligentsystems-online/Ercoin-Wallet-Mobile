import 'dart:typed_data';

import 'package:base58check/base58.dart';

import 'package:ercoin_wallet/model/base/private_key.dart';

class PrivateKeys {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static Uint8List toBytes(PrivateKey privateKey) =>
      Uint8List.fromList(_base58codec.decode(privateKey.privateKey));

  static PrivateKey fromBytes(Uint8List bytes) =>
      PrivateKey(privateKey: _base58codec.encode(bytes.toList()));
}