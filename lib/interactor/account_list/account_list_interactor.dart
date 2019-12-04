import 'dart:async';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';

//TODO(DI)
class AccountListInteractor {
  final _accountService = AccountService();
  final _activeAccountService = ActiveAccountService();

  Future<List<AccountWithBalance>> obtainAccountsWithBalance() => _accountService.obtainAccountsWithBalance();

  Future<String> obtainActiveAccountPk() => _activeAccountService.obtainActiveAccountPk();

  Future<void> activateAccount(String publicKey) => _activeAccountService.activateAccount(publicKey);
}