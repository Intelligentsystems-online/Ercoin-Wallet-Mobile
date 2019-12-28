import 'dart:core';

import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';

import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/transfer/api/transfer_api_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';

class TransferService {
  final TransferApiService _apiService;
  final ActiveLocalAccountService _activeLocalAccountService;
  final LocalAccountDetailsCacheService _localAccountCacheService;
  final ActiveAccountTransferListCacheService _transferCacheService;

  const TransferService(
      this._apiService,
      this._activeLocalAccountService,
      this._localAccountCacheService,
      this._transferCacheService
  );

  Future<ApiResponseStatus> executeTransfer(Address destination, String message, CoinsAmount amount) async {
    final activeAccount = await _activeLocalAccountService.obtainActiveAccount();
    final response = await _apiService.executeTransfer(destination, activeAccount, message, amount);

    if(response == ApiResponseStatus.SUCCESS) {
      _localAccountCacheService.invalidateCache();
      _transferCacheService.invalidateCache();
    }
    return response;
  }

  Future<List<Transfer>> obtainTransferList([TransferDirection direction]) async {
    final activeAccount = await _activeLocalAccountService.obtainActiveAccount();
    final transferList = await _transferCacheService.obtainTransferList(activeAccount);

    if(direction != null) {
      return transferList.where((transfer) => transfer.direction == direction).toList();
    } else {
      return transferList;
    }
  }
}
