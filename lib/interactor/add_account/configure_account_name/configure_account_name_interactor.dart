import 'dart:async';

import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class ConfigureAccountNameInteractor {
  final LocalAccountService _localAccountService;
  final ActiveLocalAccountService _activeLocalAccountService;

  ConfigureAccountNameInteractor(this._localAccountService, this._activeLocalAccountService);

  Future<LocalAccount> createLocalAccount(LocalAccountKeys keys, String name) async {
    final localAccount = await _localAccountService.create(keys.address, name, keys.privateKey);
    await _activeLocalAccountService.persistActiveAccount(localAccount);

    return localAccount;
  }
}
