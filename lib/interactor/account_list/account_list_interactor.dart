import 'dart:async';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';

//TODO(Interactor)
class AccountListInteractor {
  Future<List<AccountWithBalance>> obtainAccountsWithBalance() async {
    final account = AccountWithBalance(Account("public key", "private key", "account name"), 100);

    return [account];
  }

  Future<String> obtainActiveAccountPk() async {
    return "public key";
  }

  Future<void> activateAccount(String publicKey) async {
    //TODO change active account in shared preferences
  }
}