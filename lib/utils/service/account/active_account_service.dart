import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/model/account_status.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';

class ActiveAccountService {
  static final _activeAccountPreferenceKey = 'active_account';

  final CommonAccountUtil _commonAccountUtil;
  final AccountRepository _accountRepository;
  final ApiConsumerService _apiConsumerService;
  final SharedPreferencesUtil _sharedPreferencesUtil;

  ActiveAccountService(this._commonAccountUtil, this._accountRepository, this._apiConsumerService, this._sharedPreferencesUtil);

  Future<String> obtainActiveAccountPk() => _sharedPreferencesUtil.getSharedPreference(_activeAccountPreferenceKey);

  Future<void> activateAccount(String publicKey) => _sharedPreferencesUtil.setSharedPreference(_activeAccountPreferenceKey, publicKey);

  Future<AccountInfo> obtainActiveAccountInfo() async {
    final activeAccountPk = await obtainActiveAccountPk();
    final account = await _accountRepository.findByPublicKey(activeAccountPk);
    final apiResponse = await _apiConsumerService.fetchAccountDataBase64For(account.publicKey);

    return _commonAccountUtil.obtainAccountInfoFrom(apiResponse, account);
  }
}