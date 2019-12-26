import 'package:equatable/equatable.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:flutter/cupertino.dart';

@immutable
class LocalAccount extends Equatable {
  final NamedAddress namedAddress;
  final PrivateKey privateKey;

  const LocalAccount({@required this.namedAddress, @required this.privateKey});

  @override
  get props => [namedAddress];
}
