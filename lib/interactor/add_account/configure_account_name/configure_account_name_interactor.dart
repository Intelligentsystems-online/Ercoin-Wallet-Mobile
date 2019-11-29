import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';

class ConfigureAccountNameInteractor {
  final _accountRepository = AccountRepository(); // TODO(DI)

  Future<Account> addAccount(AccountKeys keys, String name) async {
    final account = Account(keys.publicKey, keys.privateKey, name);
    _accountRepository.createAccount(account);
    return account;
  }
}
