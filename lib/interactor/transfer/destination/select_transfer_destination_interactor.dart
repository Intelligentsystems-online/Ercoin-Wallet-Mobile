import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/ui/named_address_lists.dart';
import 'package:ercoin_wallet/model/ui/named_address_lists.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class SelectTransferDestinationInteractor {
  final NamedAddressService _namedAddressService;
  final LocalAccountService _accountService;
  final ActiveLocalAccountService _activeAccountService;

  SelectTransferDestinationInteractor(this._namedAddressService, this._accountService, this._activeAccountService);

  Future<List<NamedAddress>> obtainNamedAddressList() => _namedAddressService.obtainList();

  Future<NamedAddressLists> obtainNamedAddressLists(String name) async {
    final activeAccountAddress = await _activeAccountService.obtainActiveAccountAddress();
    final namedAddressList = await _obtainNamedAddressList(name);
    final localAccountList = await _obtainLocalAccountList(name);
    return NamedAddressLists(
        namedAddressList: namedAddressList,
        localAccountList: localAccountList
            .where((account) => account.namedAddress.address != activeAccountAddress)
            .toList()
    );
  }

  Future<List<LocalAccount>> _obtainLocalAccountList(String name) async =>
      name != null
      ? await _accountService.obtainListByNameContains(name)
      : await _accountService.obtainList();

  Future<List<NamedAddress>> _obtainNamedAddressList(String name) async =>
      name != null
          ? await _namedAddressService.obtainListByNameContains(name)
          : await _namedAddressService.obtainList();
}
