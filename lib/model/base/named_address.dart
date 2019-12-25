import 'package:equatable/equatable.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:flutter/cupertino.dart';

@immutable
class NamedAddress extends Equatable {
  final Address address;
  final String name;

  const NamedAddress({@required this.address, @required this.name});

  @override
  get props => [address];
}
