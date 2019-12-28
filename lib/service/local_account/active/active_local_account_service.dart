import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';

class ActiveLocalAccountService {
  static final _activeAccountPreferenceKey = 'active_account';

  final LocalAccountService _accountService;
  final LocalAccountDetailsCacheService _localAccountCacheService;
  final ActiveAccountTransferListCacheService _transferCacheService;
  final SharedPreferencesService _sharedPreferencesUtil;

  const ActiveLocalAccountService(
      this._accountService,
      this._localAccountCacheService,
      this._transferCacheService,
      this._sharedPreferencesUtil
  );

  Future<Address> obtainActiveAccountAddress() async =>
      Address.ofBase58(await _sharedPreferencesUtil.getSharedPreference(_activeAccountPreferenceKey));

  Future persistActiveAccount(LocalAccount account) async {
    await _sharedPreferencesUtil.setSharedPreference(
        _activeAccountPreferenceKey,
        account?.namedAddress?.address?.base58
    );
    _transferCacheService.invalidateCache();
    _localAccountCacheService.invalidateCache();
  }

  Future<LocalAccount> obtainActiveAccount() async =>
      await _accountService.obtainByAddress(await obtainActiveAccountAddress());

  Future<LocalAccountDetails> obtainActiveAccountDetails() async =>
      await _accountService.obtainDetailsByAddress(await obtainActiveAccountAddress());

  Future<LocalAccountActivationDetails> obtainAccountActivationDetails(LocalAccount account) async {
    final details = await _accountService.obtainDetailsByAddress(account.namedAddress.address);
    return (await _transformToActivationDetails([details])).first;
  }

  Future<List<LocalAccountActivationDetails>> obtainAccountActivationDetailsList() async =>
    await _transformToActivationDetails(await _accountService.obtainDetailsList());

  Future<List<LocalAccountActivationDetails>> obtainAccountActivationDetailsListByNameContains(String value) async =>
    await _transformToActivationDetails(await _accountService.obtainDetailsListByNameContains(value));

  Future<List<LocalAccountActivationDetails>> _transformToActivationDetails(
      List<LocalAccountDetails> detailsList
  ) async {
    final activeAddress = await obtainActiveAccountAddress();
    return detailsList.map((details) => LocalAccountActivationDetails(
      details: details,
      isActive: details.localAccount.namedAddress.address == activeAddress,
    )).toList();
  }
}
