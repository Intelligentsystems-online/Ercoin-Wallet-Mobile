import 'dart:core' as prefix0;
import 'dart:core';

import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_data.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';
import 'package:ercoin_wallet/service/transfer/api/transfer_api_service.dart';

class TransferService {
  final TransferApiService _apiService;
  final ActiveLocalAccountService _activeLocalAccountService;
  final NamedAddressService _namedAddressService;

  const TransferService(this._apiService, this._activeLocalAccountService, this._namedAddressService);

  Future<ApiResponseStatus> executeTransfer(Address destination, String message, CoinsAmount amount) async {
    final activeAccount = await _activeLocalAccountService.obtainActiveAccount();
    return _apiService.executeTransfer(destination, activeAccount, message, amount);
  }

  Future<List<Transfer>> obtainTransferList([TransferDirection direction]) async {
    final address = await _activeLocalAccountService.obtainActiveAccountAddress();
    final transferLists = await Future.wait([
      direction != TransferDirection.OUT ? _obtainAddressInTransferList(address) : Future.value([]),
      direction != TransferDirection.IN ? _obtainAddressOutTransferList(address) : Future.value([]),
    ]);
    return transferLists[0] + transferLists[1];
  }

  Future<List<Transfer>> _obtainAddressInTransferList(Address address) async =>
      await _transformTransferDataList(await _apiService.obtainInTransferDataList(address), TransferDirection.IN);

  Future<List<Transfer>> _obtainAddressOutTransferList(Address address) async =>
      await _transformTransferDataList(await _apiService.obtainOutTransferDataList(address), TransferDirection.OUT);

  Future<List<Transfer>> _transformTransferDataList(List<TransferData> dataList, TransferDirection direction) async =>
      await Future.wait(dataList.map((data) async => Transfer(
            data: data,
            direction: direction,
            foreignAddressNamed:
                await _namedAddressService.obtainByAddressOrNull(data.selectForeignAddressByDirection(direction)),
          )));
}
