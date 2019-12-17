import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class PrivateKey extends Equatable {
  static const requiredLength = 128;

  final String privateKey;

  const PrivateKey({@required this.privateKey}) : assert(privateKey.length == requiredLength);

  @override
  get props => [privateKey];
}
