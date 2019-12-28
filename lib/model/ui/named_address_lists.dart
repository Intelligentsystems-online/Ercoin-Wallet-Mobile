import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:flutter/material.dart';

@immutable
class NamedAddressLists {
  final List<NamedAddress> namedAddressList;
  final List<LocalAccount> localAccountList;

  const NamedAddressLists({@required this.namedAddressList, @required this.localAccountList});
}
