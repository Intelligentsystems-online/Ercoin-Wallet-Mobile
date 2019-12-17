import 'package:ercoin_wallet/model/named_address.dart';
import 'package:ercoin_wallet/model/private_key.dart';
import 'package:flutter/cupertino.dart';

@immutable
class LocalAccount {
  final NamedAddress namedAddress;
  final PrivateKey privateKey;

  const LocalAccount({@required this.namedAddress, @required this.privateKey});
}
