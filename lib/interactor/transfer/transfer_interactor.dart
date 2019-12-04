import 'dart:async';

import 'package:ercoin_wallet/interactor/transfer/send_transfer_error.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transaction_transfer_service.dart';

//TODO(DI)
class TransferInteractor {
  final _activeAccountService = ActiveAccountService();
  final _transactionTransferService = TransactionTransferService();

  Future<SendTransferError> sendTransfer(String destinationAddress, String message, double amount) async {
    final activeAccountPk = await _activeAccountService.obtainActiveAccountPk();

    await _transactionTransferService.executeTransactionTransfer(activeAccountPk, destinationAddress, message, amount);

    return null;
  }
}
