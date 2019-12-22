import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:ercoin_wallet/model/base/addresses.dart';
import 'package:flutter/foundation.dart';

@immutable
class Address extends Equatable {
  static const requiredLength = 32;

  final Uint8List bytes;

  const Address({@required this.bytes}) : assert(bytes.length == requiredLength);

  String get publicKey => Addresses.toString(bytes);

  @override
  get props => [bytes];
}
