import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';

// TODO(DI)
class ConfigureAccountNameInteractor {
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _accountRepository = AccountRepository();

  Future<Account> addAccount(AccountKeys keys, String name) async {
    final account = Account(keys.publicKey, keys.privateKey, name);
    _accountRepository
        .createAccount(account)
        .then((_) => _sharedPreferencesUtil.setSharedPreference("active_account", account.publicKey));

    return account;
  }
}
