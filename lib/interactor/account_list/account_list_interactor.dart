import 'dart:async';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';

//TODO(DI)
class AccountListInteractor {
  final _accountService = AccountService();
  final _activeAccountService = ActiveAccountService();

  Future<List<AccountInfo>> obtainAccountsWithBalance() => _accountService.obtainAccountsInfo();

  Future<String> obtainActiveAccountPk() => _activeAccountService.obtainActiveAccountPk();

  Future<void> activateAccount(String publicKey) => _activeAccountService.activateAccount(publicKey);
}