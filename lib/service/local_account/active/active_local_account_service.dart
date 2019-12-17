import 'dart:async';

import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/local_account_details.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_util.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class ActiveLocalAccountService {
  static final _activeAccountPreferenceKey = 'active_account';

  final LocalAccountService _accountService;
  final SharedPreferencesUtil _sharedPreferencesUtil;

  const ActiveLocalAccountService(this._accountService, this._sharedPreferencesUtil);

  Future<Address> obtainActiveAccountAddress() async =>
      Address(publicKey: await _sharedPreferencesUtil.getSharedPreference(_activeAccountPreferenceKey));

  Future persistActiveAccountAddress(Address address) async =>
      await _sharedPreferencesUtil.setSharedPreference(_activeAccountPreferenceKey, address.publicKey);

  Future<LocalAccountDetails> obtainActiveAccountDetails() async =>
      await _accountService.obtainDetailsByAddress(await obtainActiveAccountAddress());
}
