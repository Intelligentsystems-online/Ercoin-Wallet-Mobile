import 'dart:async';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';

// TODO(Interactor)
class HomeInteractor {
  Future<AccountWithBalance> activeAccountWithBalance() {
    return Future.value(AccountWithBalance(
        Account("public key", "private key", "account name"),
        0));
  }
}