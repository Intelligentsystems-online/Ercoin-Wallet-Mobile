import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/model/account_status.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';

//TODO(DI)
class ActiveAccountService {
  static final _activeAccountPreference = 'active_account';

  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _commonAccountUtil = CommonAccountUtil();
  final _accountRepository = AccountRepository();
  final _apiConsumerService = ApiConsumerService();

  Future<String> obtainActiveAccountPk() => _sharedPreferencesUtil.getSharedPreference(_activeAccountPreference);

  Future<void> activateAccount(String publicKey) => _sharedPreferencesUtil.setSharedPreference(_activeAccountPreference, publicKey);

  Future<AccountInfo> obtainActiveAccountInfo() async {
    final activeAccountPk = await obtainActiveAccountPk();
    final account = await _accountRepository.findByPublicKey(activeAccountPk);
    final apiResponse = await _apiConsumerService.fetchAccountDataBase64For(account.publicKey);

    return _commonAccountUtil.obtainAccountInfoFrom(apiResponse, account);
  }
}