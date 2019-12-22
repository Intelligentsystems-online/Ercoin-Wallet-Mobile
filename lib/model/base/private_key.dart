import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class PrivateKey extends Equatable {
  static const requiredBytesLength = 64;

  final String privateKey;

  const PrivateKey({@required this.privateKey});

  @override
  get props => [privateKey];
}
