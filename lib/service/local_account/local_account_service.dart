import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/service/local_account/api/local_account_api_service.dart';

class LocalAccountService {
  final LocalAccountRepository _repository;
  final LocalAccountApiService _apiService;

  const LocalAccountService(this._repository, this._apiService);

  Future<List<LocalAccount>> obtainList() async => await _repository.findAll();

  Future<List<LocalAccountDetails>> obtainDetailsList() async {
    final accounts = await _repository.findAll();
    final detailsFutures = accounts.map((account) => _apiService.obtainAccountDetails(account));

    return await Future.wait(detailsFutures);
  }

  Future<List<LocalAccountDetails>> obtainDetailsListByNameContains(String name) async {
    final accounts = await _repository.findByNameContains(name);
    final detailsFutures = accounts.map((account) => _apiService.obtainAccountDetails(account));
    return await Future.wait(detailsFutures);
  }

  Future<LocalAccount> obtainByAddress(Address address) async =>
      await _repository.findByAddressOrNull(address);

  Future<LocalAccountDetails> obtainDetailsByAddress(Address address) async =>
      await _apiService.obtainAccountDetails(await obtainByAddress(address));

  Future<LocalAccount> create(Address address, String name, PrivateKey privateKey) async =>
      await _repository.create(address, name, privateKey);

  Future<bool> exists(Address address) async =>
      _repository.findByAddressOrNull(address) == null ? false : true;
}
