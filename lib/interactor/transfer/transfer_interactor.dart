import 'dart:async';

import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/utils/service/account/active_local_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';

class TransferInteractor {
  final ActiveAccountService _activeAccountService ;
  final TransferService _transferService;

  TransferInteractor(this._activeAccountService, this._transferService);

  Future<ApiResponseStatus> sendTransfer(String destinationAddress, String message, double amount) async {
    final activeAccountPk = await _activeAccountService.obtainActiveAccountPk();

    return _transferService.executeTransfer(activeAccountPk, destinationAddress, message, amount);
  }
}
