import 'dart:async';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';

//TODO(DI)
class ActiveAccountService {
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _commonAccountUtil = CommonAccountUtil();
  final _accountRepository = AccountRepository();

  Future<String> obtainActiveAccountPk() => _sharedPreferencesUtil.getSharedPreference('active_account');

  Future<void> activateAccount(String publicKey) => _sharedPreferencesUtil.setSharedPreference('active_account', publicKey);

  Future<AccountWithBalance> obtainActiveAccountWithBalance() async {
    final activeAccountPk = await obtainActiveAccountPk();
    final account = await _accountRepository.findByPublicKey(activeAccountPk);

    return _commonAccountUtil.toAccountWithBalance(account);
  }
}