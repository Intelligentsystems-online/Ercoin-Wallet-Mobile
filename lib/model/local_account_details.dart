import 'package:ercoin_wallet/model/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account.dart';
import 'package:flutter/cupertino.dart';

@immutable
class LocalAccountDetails {
  final LocalAccount localAccount;
  final CoinsAmount balance;
  final bool isRegistered;

  const LocalAccountDetails({
    @required this.localAccount,
    @required this.balance,
    @required this.isRegistered
  }) : assert(isRegistered || balance != const CoinsAmount(ercoin: 0));
}
