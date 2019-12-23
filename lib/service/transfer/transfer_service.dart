import 'dart:core';

import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';

import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/transfer/api/transfer_api_service.dart';
import 'package:ercoin_wallet/service/transfer/transfer_cache_service.dart';

class TransferService {
  final TransferApiService _apiService;
  final ActiveLocalAccountService _activeLocalAccountService;
  final TransferCacheService _transferCacheService;

  TransferService(this._apiService, this._activeLocalAccountService, this._transferCacheService);

  Future<ApiResponseStatus> executeTransfer(Address destination, String message, CoinsAmount amount) async {
    final activeAccount = await _activeLocalAccountService.obtainActiveAccount();
    final response = await _apiService.executeTransfer(destination, activeAccount, message, amount);

    if(response == ApiResponseStatus.SUCCESS)
      _transferCacheService.invalidateCacheFor(activeAccount.namedAddress.address);

    return response;
  }

  Future<List<Transfer>> obtainTransferList() async {
    final activeAccount = await _activeLocalAccountService.obtainActiveAccount();

    return _transferCacheService.obtainTransferList(activeAccount.namedAddress.address);
  }
}
