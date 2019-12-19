import 'dart:async';

import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';

class AccountInfoInteractor {
  final ActiveLocalAccountService _activeLocalAccountService;
  final TransferService _transferService;

  AccountInfoInteractor(this._activeLocalAccountService, this._transferService);

  Future<LocalAccountDetails> obtainActiveLocalAccountDetails() => _activeLocalAccountService.obtainActiveAccountDetails();

  Future<List<Transfer>> obtainRecentTransfers() async {
    final transferList = await _transferService.obtainTransferList();
    transferList.sort(_compareByTimestamp);

    return _obtainLimitedTransfers(5, transferList);
  }

  int _compareByTimestamp(Transfer t1, Transfer t2) => t2.data.timestamp.compareTo(t1.data.timestamp);

  List<Transfer> _obtainLimitedTransfers(int limit, List<Transfer> transferList) =>
      (transferList.length < limit) ? transferList.sublist(0, transferList.length) : transferList.sublist(0, limit);
}
