import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:flutter/foundation.dart';


@immutable
class LocalAccountDetails {
  final LocalAccount localAccount;
  final CoinsAmount balance;
  final bool isRegistered;

  const LocalAccountDetails._(this.localAccount, this.balance, this.isRegistered);

  static LocalAccountDetails of({@required LocalAccount localAccount,
                                 @required CoinsAmount balance,
                                 @required bool isRegistered}) {
    if(isRegistered || balance == CoinsAmount.ofErcoin(0.0))
      return LocalAccountDetails._(localAccount, balance, isRegistered);
    else
      throw FormatException("Cannot create LocalAccountDetails object due to invalid params");
  }
}
