import 'dart:async';

import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/ui/local_account_details_with_recent_transfers.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';

class AccountInfoInteractor {
  final ActiveLocalAccountService _activeLocalAccountService;
  final LocalAccountDetailsCacheService _accountDetailsCacheService;
  final TransferService _transferService;
  final ActiveAccountTransferListCacheService _transferCacheService;

  AccountInfoInteractor(
      this._activeLocalAccountService,
      this._accountDetailsCacheService,
      this._transferService,
      this._transferCacheService
  );

  Future<LocalAccountDetailsWithRecentTransfers> obtainActiveLocalAccountDetailsWithRecentTransfers({
    bool refresh = false
  }) async {
    if(refresh) {
      _accountDetailsCacheService.invalidateCache();
      _transferCacheService.invalidateCache();
    }
    return LocalAccountDetailsWithRecentTransfers(
      details: await _activeLocalAccountService.obtainActiveAccountDetails(),
      recentTransfers: await _obtainRecentTransfers(),
    );
  }

  Future<List<Transfer>> _obtainRecentTransfers() async {
    final transferList = await _transferService.obtainTransferList();
    transferList.sort(_compareByTimestamp);

    return _obtainLimitedTransfers(5, transferList);
  }

  int _compareByTimestamp(Transfer t1, Transfer t2) => t2.data.timestamp.compareTo(t1.data.timestamp);

  List<Transfer> _obtainLimitedTransfers(int limit, List<Transfer> transferList) =>
      (transferList.length < limit) ? transferList.sublist(0, transferList.length) : transferList.sublist(0, limit);
}
