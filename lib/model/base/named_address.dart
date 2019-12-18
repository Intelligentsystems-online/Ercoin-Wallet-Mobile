import 'package:ercoin_wallet/model/base/address.dart';
import 'package:flutter/cupertino.dart';

@immutable
class NamedAddress {
  final Address address;
  final String name;

  const NamedAddress({@required this.address, @required this.name});
}
