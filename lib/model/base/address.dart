import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Address extends Equatable {
  static const requiredBytesLength = 32;

  final String publicKey;

  const Address({@required this.publicKey});

  @override
  get props => [publicKey];
}
