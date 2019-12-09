import 'dart:async';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';

//TODO(DI)
class AccountListInteractor {
  final AccountService accountService;
  final ActiveAccountService activeAccountService;

  AccountListInteractor({this.accountService, this.activeAccountService});

  Future<List<AccountInfo>> obtainAccountsWithBalance() => accountService.obtainAccountsInfo();

  Future<String> obtainActiveAccountPk() => activeAccountService.obtainActiveAccountPk();

  Future<void> activateAccount(String publicKey) => activeAccountService.activateAccount(publicKey);
}