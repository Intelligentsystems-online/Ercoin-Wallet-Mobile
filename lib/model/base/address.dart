import 'dart:typed_data';

import 'package:base58check/base58.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Address extends Equatable {
  static final String _ercoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static final Base58Codec _base58codec = Base58Codec(_ercoinAlphabet);

  static const requiredLength = 32;

  final Uint8List bytes;

  const Address({@required this.bytes}) : assert(bytes.length == requiredLength);

  String get publicKey => _base58codec.encode(bytes);

  @override
  get props => [bytes];
}
