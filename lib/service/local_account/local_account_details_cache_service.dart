import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';

import 'api/local_account_api_service.dart';

class LocalAccountDetailsCacheService {
  static final Duration _maxCacheAge = Duration(minutes: 5);

  List<LocalAccountDetails> _localAccountDetailsList;
  DateTime _lastUpdate;

  final LocalAccountRepository _repository;
  final LocalAccountApiService _apiService;

  LocalAccountDetailsCacheService(this._repository, this._apiService);

  Future<List<LocalAccountDetails>> obtainDetailsList() async {
    if(_shouldUpdate())
      await _update();

    return _localAccountDetailsList;
  }

  invalidateCache() => _lastUpdate = null;

  Future _update() async {
    final accounts = await _repository.findAll();
    final detailsFutures = accounts.map((account) => _apiService.obtainAccountDetails(account)).toList();

    _lastUpdate = DateTime.now();
    _localAccountDetailsList = await Future.wait(detailsFutures);
  }

  bool _shouldUpdate() => _lastUpdate == null || DateTime.now().difference(_lastUpdate) > _maxCacheAge;
}