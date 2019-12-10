import 'dart:async';

import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/transfer/transfer_service.dart';

class TransferInteractor {
  final ActiveAccountService activeAccountService ;
  final TransferService transferService;

  TransferInteractor({this.activeAccountService, this.transferService});

  Future<ApiResponseStatus> sendTransfer(String destinationAddress, String message, double amount) async {
    final activeAccountPk = await activeAccountService.obtainActiveAccountPk();

    return transferService.executeTransfer(activeAccountPk, destinationAddress, message, amount);
  }
}
