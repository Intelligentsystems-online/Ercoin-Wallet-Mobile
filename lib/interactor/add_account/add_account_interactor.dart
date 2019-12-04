import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';

//TODO(DI)
class AddAccountInteractor {
  final _accountService = AccountService();

  Future<AccountKeys> generateAccountKeys() => _accountService.generateAccountKeys();
}
