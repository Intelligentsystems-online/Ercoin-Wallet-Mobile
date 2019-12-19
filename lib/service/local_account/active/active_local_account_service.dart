import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class ActiveLocalAccountService {
  static final _activeAccountPreferenceKey = 'active_account';

  final LocalAccountService _accountService;
  final SharedPreferencesService _sharedPreferencesUtil;

  const ActiveLocalAccountService(this._accountService, this._sharedPreferencesUtil);

  Future<Address> obtainActiveAccountAddress() async =>
      Address(publicKey: await _sharedPreferencesUtil.getSharedPreference(_activeAccountPreferenceKey));

  Future persistActiveAccountAddress(Address address) async =>
      await _sharedPreferencesUtil.setSharedPreference(_activeAccountPreferenceKey, address.publicKey);

  Future<LocalAccount> obtainActiveAccount() async =>
      await _accountService.obtainByAddress(await obtainActiveAccountAddress());

  Future<LocalAccountDetails> obtainActiveAccountDetails() async =>
      await _accountService.obtainDetailsByAddress(await obtainActiveAccountAddress());
}
