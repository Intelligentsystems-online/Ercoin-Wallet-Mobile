import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class ActiveLocalAccountService {
  static final _activeAccountPreferenceKey = 'active_account';

  final LocalAccountService _accountService;
  final LocalAccountDetailsCacheService _localAccountCacheService;
  final SharedPreferencesService _sharedPreferencesUtil;

  const ActiveLocalAccountService(this._accountService, this._localAccountCacheService, this._sharedPreferencesUtil);

  Future<Address> obtainActiveAccountAddress() async =>
      Address(publicKey: await _sharedPreferencesUtil.getSharedPreference(_activeAccountPreferenceKey));

  Future persistActiveAccount(LocalAccount account) async {
    await _sharedPreferencesUtil.setSharedPreference(
        _activeAccountPreferenceKey,
        account?.namedAddress?.address?.publicKey
    );
    _localAccountCacheService.invalidateCache();
  }

  Future<LocalAccount> obtainActiveAccount() async =>
      await _accountService.obtainByAddress(await obtainActiveAccountAddress());

  Future<LocalAccountDetails> obtainActiveAccountDetails() async =>
      await _accountService.obtainDetailsByAddress(await obtainActiveAccountAddress());

  Future<LocalAccountActivationDetails> obtainAccountActivationDetails(LocalAccount account) async =>
      LocalAccountActivationDetails(
        details: await _accountService.obtainDetailsByAddress(account.namedAddress.address),
        isActive: await obtainActiveAccountAddress() == account.namedAddress.address,
      );
}
