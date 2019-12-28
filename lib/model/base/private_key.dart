import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'package:base58check/base58.dart';
import 'package:flutter/foundation.dart';


class PrivateKey extends Equatable {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static const requiredLength = 64;

  final Uint8List bytes;

  const PrivateKey({@required this.bytes}) : assert(bytes.length == requiredLength);

  static PrivateKey ofBase58(String base58) =>
      PrivateKey(bytes: _base58codec.decode(base58));

  String get base58 => _base58codec.encode(bytes);

  @override
  get props => [bytes];
}
