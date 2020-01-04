import 'dart:typed_data';
import 'dart:convert' as base64Converter;

import 'package:convert/convert.dart' as hexConverter;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:base58check/base58.dart';


@immutable
class Address extends Equatable {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static const requiredLength = 32;

  final Uint8List _bytes;

  const Address._(this._bytes);

  static Address ofBytes(Uint8List bytes) {
    if(bytes.length == requiredLength) {
      return Address._(bytes);
    } else {
      throw FormatException("Invalid address length");
    }
  }

  static Address ofBase58(String base58) {
    try {
      return ofBytes(_base58codec.decode(base58));
    } catch(_) {
      throw FormatException("Invalid address format");
    }
  }

  Uint8List get bytes => _bytes;
  String get base58 => _base58codec.encode(bytes);
  String get base64 => base64Converter.base64.encode(bytes);
  String get hex => hexConverter.hex.encode(bytes);

  @override
  get props => [bytes];
}
