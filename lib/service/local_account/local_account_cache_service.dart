import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';

import 'api/local_account_api_service.dart';

class LocalAccountCacheService {
  static final Duration _invalidateDuration = Duration(minutes: 5);

  DateTime _lastInvalidateDate;
  List<LocalAccountDetails> _localAccountDetailsList;

  final LocalAccountRepository _repository;
  final LocalAccountApiService _apiService;

  LocalAccountCacheService(this._repository, this._apiService);

  Future<LocalAccountDetails> obtainDetailsByAddress(Address address) async {
    if(_shouldInvalidateCache()) {
      await invalidateCache();
    }

    return _localAccountDetailsList
        .firstWhere((account) => account.localAccount.namedAddress.address == address);
  }

  Future<List<LocalAccountDetails>> obtainDetailsList() async {
    if(_shouldInvalidateCache()) {
      await invalidateCache();
    }

    return _localAccountDetailsList;
  }

  Future<List<LocalAccountDetails>> obtainDetailsListByNameContains(String name) async {
    if(_shouldInvalidateCache())
      await invalidateCache();

    return _localAccountDetailsList
        .where((account) => account.localAccount.namedAddress.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future invalidateCache() async {
    _lastInvalidateDate = DateTime.now();
    _localAccountDetailsList = await _fetchDetailsList();
  }

  Future<List<LocalAccountDetails>> _fetchDetailsList() async {
    final accounts = await _repository.findAll();
    final detailsFutures = accounts.map((account) => _apiService.obtainAccountDetails(account));

    return await Future.wait(detailsFutures);
  }

  bool _shouldInvalidateCache() => _localAccountDetailsList == null || _isCacheExpired();

  bool _isCacheExpired() => DateTime.now().difference(_lastInvalidateDate) > _invalidateDuration;
}