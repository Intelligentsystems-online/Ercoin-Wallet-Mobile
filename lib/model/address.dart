import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Address extends Equatable {
  static const requiredPublicKeyLength = 64;

  final String publicKey;

  const Address({@required this.publicKey}) : assert(publicKey.length == requiredPublicKeyLength);

  @override
  get props => [publicKey];
}
