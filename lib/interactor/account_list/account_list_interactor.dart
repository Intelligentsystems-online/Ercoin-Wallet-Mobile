import 'dart:async';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';

class AccountListInteractor {
  final AccountService _accountService;
  final ActiveAccountService _activeAccountService;
  final CommonAccountUtil _commonAccountUtil;

  AccountListInteractor(this._accountService, this._activeAccountService, this._commonAccountUtil);

  Future<List<AccountInfo>> obtainAccountsWithBalance() => _accountService.obtainAccountsInfo();

  Future<String> obtainActiveAccountPk() => _activeAccountService.obtainActiveAccountPk();

  Future<void> activateAccount(String publicKey) => _activeAccountService.activateAccount(publicKey);

  List<AccountInfo> filterAccountsInfoBy(String value, List<AccountInfo> accounts) => _commonAccountUtil
      .filterAccountsInfoBy(value, accounts);
}