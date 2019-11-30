
import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';

class AccountInfoInteractor {
  Future<AccountWithBalance> activeAccountWithBalance() async {
    return AccountWithBalance(Account("public key", "private key", "account name"), 0);
  }

  Future<List<Transaction>> fetchRecentTransactions() async {
    var transaction = Transaction("receiver address", "sender address", 100, "message", 57000);

    return [transaction];
  }
}