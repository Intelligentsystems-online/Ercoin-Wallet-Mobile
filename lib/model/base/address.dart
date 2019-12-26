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

  final Uint8List bytes;

  const Address({@required this.bytes}) : assert(bytes.length == requiredLength);

  static Address ofBase58(String base58) =>
      Address(bytes: _base58codec.decode(base58));

  static Address ofBase64(String base64) =>
      Address(bytes: base64Converter.base64.decode(base64));

  static Address ofHex(String hex) =>
      Address(bytes: hexConverter.hex.decode(hex));

  String get base58 => _base58codec.encode(bytes);
  String get base64 => base64Converter.base64.encode(bytes);
  String get hex => hexConverter.hex.encode(bytes);

  @override
  get props => [bytes];
}
