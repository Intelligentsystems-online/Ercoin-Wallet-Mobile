import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'package:base58check/base58.dart';
import 'package:flutter/foundation.dart';


class PrivateKey extends Equatable {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static const requiredLength = 64;

  final Uint8List _bytes;

  const PrivateKey._(this._bytes);

  static PrivateKey ofBytes(Uint8List bytes) {
    if(bytes.length == requiredLength)
      return PrivateKey._(bytes);
    else
      throw FormatException("Invalid private key length");
  }

  static PrivateKey ofBase58(String base58) {
    try {
      return ofBytes(_base58codec.decode(base58));
    } catch(_) {
      throw FormatException("Invalid private key format");
    }
  }

  Uint8List get bytes => _bytes;
  String get base58 => _base58codec.encode(bytes);

  @override
  get props => [bytes];
}
