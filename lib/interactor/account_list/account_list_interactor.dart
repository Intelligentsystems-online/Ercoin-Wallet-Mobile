import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';


class AccountListInteractor {
  final LocalAccountService _localAccountService;
  final ActiveLocalAccountService _activeLocalAccountService;
  final LocalAccountDetailsCacheService _detailsCacheService;

  AccountListInteractor(this._localAccountService, this._activeLocalAccountService, this._detailsCacheService);

  Future<List<LocalAccountActivationDetails>> obtainDetailsList(String search, {bool refresh = false}) async {
    if(refresh) {
      _detailsCacheService.invalidateCache();
    }
    if(search == null || search.isEmpty) {
      return _activeLocalAccountService.obtainAccountActivationDetailsList();
    } else {
      return _activeLocalAccountService.obtainAccountActivationDetailsListByNameContains(search);
    }
  }

  Future persistActiveAccountAddress(LocalAccount account) => _activeLocalAccountService.persistActiveAccount(account);

  Future<Address> obtainActiveAccountAddress() => _activeLocalAccountService.obtainActiveAccountAddress();

  Future<List<LocalAccountDetails>> obtainAccountDetailsListByNameContains(String value) =>
      _localAccountService.obtainDetailsListByNameContains(value);
}
