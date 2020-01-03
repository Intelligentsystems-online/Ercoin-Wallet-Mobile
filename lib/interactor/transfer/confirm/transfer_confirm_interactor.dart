import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';

class TransferConfirmInteractor {

  final TransferService _transferService;

  const TransferConfirmInteractor(this._transferService);

  Future<ApiResponseStatus> sendTransfer(Address destinationAddress, String message, CoinsAmount coinsAmount) =>
      _transferService.executeTransfer(destinationAddress, message, coinsAmount);
}
