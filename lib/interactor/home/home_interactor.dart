import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';

class HomeInteractor {
  final LocalAccountDetailsCacheService _localAccountDetailsCacheService;
  final ActiveAccountTransferListCacheService _transferCacheService;

  HomeInteractor(this._localAccountDetailsCacheService, this._transferCacheService);

  Future invalidateApplicationCache() async {
    await _localAccountDetailsCacheService.invalidateCache();
    await _transferCacheService.invalidateCache();
  }
}