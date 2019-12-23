import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class LocalAccountCacheService {
  static final Duration _invalidateDuration = Duration(minutes: 5);

  DateTime _lastInvalidateDate;
  List<LocalAccountDetails> _localAccountDetailsList;

  final LocalAccountService _localAccountService;

  LocalAccountCacheService(this._localAccountService);

  Future<List<LocalAccountDetails>> obtainLocalAccountDetailsList() async {
    if(_shouldInvalidateCache()) {
      await invalidateCache();
      return _localAccountDetailsList;
    }
    else
      return _localAccountDetailsList;
  }

  Future invalidateCache() async {
    _lastInvalidateDate = DateTime.now();
    _localAccountDetailsList = await _localAccountService.obtainDetailsList();
  }

  bool _shouldInvalidateCache() => _localAccountDetailsList == null || _isCacheExpired();

  bool _isCacheExpired() => DateTime.now().difference(_lastInvalidateDate) > _invalidateDuration;
}