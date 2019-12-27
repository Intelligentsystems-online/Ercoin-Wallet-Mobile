import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';

import 'transfer_list_service.dart';

class ActiveAccountTransferListCacheService {
  static final Duration _invalidateDuration = Duration(minutes: 5);

  List<Transfer> _transferList;
  LocalAccount _loadedAccount;
  DateTime _lastUpdate;

  final TransferListService _transferListService;

  ActiveAccountTransferListCacheService(this._transferListService);

  Future<List<Transfer>> obtainTransferList(LocalAccount account) async {
    if(_loadedAccount != account || _shouldUpdate())
      await _update(account);

    return _transferList;
  }

  invalidateCache() => _lastUpdate = null;

  bool _shouldUpdate() => _lastUpdate == null || DateTime.now().difference(_lastUpdate) > _invalidateDuration;

  Future _update(LocalAccount account) async {
    _transferList = await _transferListService.fetchTransferList(account.namedAddress.address);
    _loadedAccount = account;
    _lastUpdate = DateTime.now();
  }
}