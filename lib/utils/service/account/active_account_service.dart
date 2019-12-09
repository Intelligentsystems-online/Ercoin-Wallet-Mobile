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
  static final _activeAccountPreferenceKey = 'active_account';

  final CommonAccountUtil commonAccountUtil;
  final AccountRepository accountRepository;
  final ApiConsumerService apiConsumerService;
  final SharedPreferencesUtil sharedPreferencesUtil;

  ActiveAccountService({this.commonAccountUtil, this.accountRepository, this.apiConsumerService, this.sharedPreferencesUtil});

  Future<String> obtainActiveAccountPk() => sharedPreferencesUtil.getSharedPreference(_activeAccountPreferenceKey);

  Future<void> activateAccount(String publicKey) => sharedPreferencesUtil.setSharedPreference(_activeAccountPreferenceKey, publicKey);

  Future<AccountInfo> obtainActiveAccountInfo() async {
    final activeAccountPk = await obtainActiveAccountPk();
    final account = await accountRepository.findByPublicKey(activeAccountPk);
    final apiResponse = await apiConsumerService.fetchAccountDataBase64For(account.publicKey);

    return commonAccountUtil.obtainAccountInfoFrom(apiResponse, account);
  }
}