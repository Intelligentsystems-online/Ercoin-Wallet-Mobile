import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';


class AccountListInteractor {
  final LocalAccountService _localAccountService;
  final ActiveLocalAccountService _activeLocalAccountService;

  AccountListInteractor(this._localAccountService, this._activeLocalAccountService);

  Future<List<LocalAccountDetails>> obtainAccountDetailsList() => _localAccountService.obtainDetailsList();

  Future<Address> obtainActiveAccountAddress() => _activeLocalAccountService.obtainActiveAccountAddress();

  Future<List<LocalAccountDetails>> obtainAccountDetailsListByNameContains(String value) =>
      _localAccountService.obtainDetailsListByNameContains(value);
}
