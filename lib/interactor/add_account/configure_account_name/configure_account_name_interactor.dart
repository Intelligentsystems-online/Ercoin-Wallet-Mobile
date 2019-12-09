import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';

// TODO(DI)
class ConfigureAccountNameInteractor {
  final _accountService = AccountService();
  final _activeAccountService = ActiveAccountService();

  Future<Account> addAccount(AccountKeys keys, String name) async {
    final account = await _accountService.saveAccount(keys.publicKey, keys.privateKey, name);
    await _activeAccountService.activateAccount(keys.publicKey);

    return account;
  }
}
