import 'dart:async';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';

class AccountListInteractor {
  final AccountService _accountService;
  final ActiveAccountService _activeAccountService;

  AccountListInteractor(this._accountService, this._activeAccountService);

  Future<List<AccountInfo>> obtainAccountsWithBalance() => _accountService.obtainAccountsInfo();

  Future<String> obtainActiveAccountPk() => _activeAccountService.obtainActiveAccountPk();

  Future<void> activateAccount(String publicKey) => _activeAccountService.activateAccount(publicKey);

  Future<List<AccountInfo>> obtainAccountsInfoByName(String value) => _accountService.obtainAccountsInfoByNameLike(value);
}