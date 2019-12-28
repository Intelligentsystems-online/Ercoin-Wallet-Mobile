import 'dart:async';

import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';

class TransferListInteractor {
  final TransferService _transferService;
  final ActiveAccountTransferListCacheService _cacheService;

  TransferListInteractor(this._transferService, this._cacheService);

  Future<List<Transfer>> obtainTransferList(TransferDirection direction, {bool refresh}) async {
    if(refresh) {
      _cacheService.invalidateCache();
    }
    return await _transferService.obtainTransferList(direction);
  }
}
