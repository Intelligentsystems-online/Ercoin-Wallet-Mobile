import 'dart:async';

import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';

//TODO(DI)
class TransferInteractor {
  final _activeAccountService = ActiveAccountService();
  final _transactionTransferService = TransferService();

  Future<ApiResponseStatus> sendTransfer(String destinationAddress, String message, double amount) async {
    final activeAccountPk = await _activeAccountService.obtainActiveAccountPk();

    return _transactionTransferService.executeTransfer(activeAccountPk, destinationAddress, message, amount);
  }
}
