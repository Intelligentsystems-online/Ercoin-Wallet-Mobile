import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/service/local_account/local_account_cache_service.dart';

class LocalAccountService {
  final LocalAccountRepository _repository;
  final LocalAccountCacheService _localAccountCacheService;

  const LocalAccountService(this._repository, this._localAccountCacheService);

  Future<List<LocalAccount>> obtainList() async => await _repository.findAll();

  Future<List<LocalAccountDetails>> obtainDetailsList() async => _localAccountCacheService.obtainDetailsList();

  Future<List<LocalAccountDetails>> obtainDetailsListByNameContains(String name) async {
    final details = await _localAccountCacheService.obtainDetailsList();

    return details
        .where((account) => _isAccountContainsName(account.localAccount, name))
        .toList();
  }

  bool _isAccountContainsName(LocalAccount account, String name) => account
      .namedAddress
      .name
      .toLowerCase()
      .contains(name.toLowerCase());

  Future<LocalAccount> obtainByAddress(Address address) async =>
      await _repository.findByAddressOrNull(address);

  Future<LocalAccountDetails> obtainDetailsByAddress(Address address) async {
    final details = await _localAccountCacheService
        .obtainDetailsList();

    return details
        .firstWhere((account) => account.localAccount.namedAddress.address == address);
  }

  Future<LocalAccount> create(Address address, String name, PrivateKey privateKey) async =>
      await _repository.create(address, name, privateKey);

  Future<bool> exists(Address address) async =>
      await _repository.findByAddressOrNull(address) == null ? false : true;
}
