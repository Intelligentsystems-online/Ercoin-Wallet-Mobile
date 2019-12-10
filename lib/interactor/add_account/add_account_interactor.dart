import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';

class AddAccountInteractor {
  final AccountService _accountService;

  AddAccountInteractor(this._accountService);

  Future<AccountKeys> generateAccountKeys() => _accountService.generateAccountKeys();
}
