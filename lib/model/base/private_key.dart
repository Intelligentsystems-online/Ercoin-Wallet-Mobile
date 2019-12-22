import 'dart:typed_data';

import 'package:base58check/base58.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class PrivateKey extends Equatable {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static const requiredLength = 64;

  final Uint8List bytes;

  const PrivateKey({@required this.bytes}) : assert(bytes.length == requiredLength);

  String get privateKey => _base58codec.encode(bytes);

  @override
  get props => [bytes];
}
