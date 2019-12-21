import 'dart:typed_data';

import 'package:ercoin_wallet/model/base/address.dart';

import 'package:base58check/base58.dart';

class Addresses {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static Uint8List toBytes(Address address) =>
      Uint8List.fromList(_base58codec.decode(address.publicKey));

  static Address fromBytes(Uint8List bytes) => Address(publicKey: _base58codec.encode(bytes.toList()));
}