import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

// TODO(Interactor)
class ConfigureAccountNameInteractor {
  Future<Account> addAccount(AccountKeys keys, String name) async {
    return Account("pubkey", "privkey", name);
  }
}
