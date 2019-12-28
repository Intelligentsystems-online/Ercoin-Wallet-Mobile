import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/service/transfer/api/transfer_api_service.dart';

import 'transfer_list_service.dart';

class ActiveAccountTransferListCacheService {
  static final Duration _invalidateDuration = Duration(minutes: 5);

  List<Transfer> _transferList;
  LocalAccount _loadedAccount;
  DateTime _lastUpdate;
  int _lastInPage = 1;
  int _lastOutPage = 1;

  final TransferListService _transferListService;
  final TransferApiService _transferApiService;

  ActiveAccountTransferListCacheService(this._transferListService, this._transferApiService);

  Future<List<Transfer>> obtainTransferList(LocalAccount account) async {
    if(_loadedAccount != account || _shouldUpdate())
      await _update(account);

    return _transferList;
  }

  invalidateCache() => _lastUpdate = null;

  bool _shouldUpdate() => _lastUpdate == null || DateTime.now().difference(_lastUpdate) > _invalidateDuration;

  Future _update(LocalAccount account) async {
    _lastInPage = await _transferApiService.fetchInTransfersLastPageNumber(account.namedAddress.address);
    _lastOutPage = await _transferApiService.fetchOutTransfersLastPageNumber(account.namedAddress.address);
    _transferList = await _transferListService.fetchTransferList(account.namedAddress.address, _lastInPage, _lastOutPage);
    _loadedAccount = account;
    _lastUpdate = DateTime.now();
  }
}