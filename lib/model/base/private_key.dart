import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:ercoin_wallet/model/base/private_keys.dart';
import 'package:flutter/cupertino.dart';

class PrivateKey extends Equatable {
  static const requiredLength = 64;

  final Uint8List bytes;

  const PrivateKey({@required this.bytes}) : assert(bytes.length == requiredLength);

  String get privateKey => PrivateKeys.toString(bytes);

  @override
  get props => [bytes];
}
