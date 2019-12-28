import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_data.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/model/transfer/utils/transfers.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

import 'api/transfer_api_service.dart';

class TransferListService {
  final TransferApiService _apiService;
  final NamedAddressService _namedAddressService;

  TransferListService(this._apiService, this._namedAddressService);

  Future<List<Transfer>> fetchTransferList(Address address, int inPageNumber, int outPageNumber) async {
    final transferLists = await Future.wait([
      _obtainAddressInTransferList(address, inPageNumber),
      _obtainAddressOutTransferList(address, outPageNumber),
    ]);
    return transferLists[0] + transferLists[1];
  }

  Future<List<Transfer>> _obtainAddressInTransferList(Address address, int pageNumber) async =>
      await _transformTransferDataList(await _apiService.obtainInTransferDataList(address, pageNumber), TransferDirection.IN);

  Future<List<Transfer>> _obtainAddressOutTransferList(Address address, int pageNumber) async =>
      await _transformTransferDataList(await _apiService.obtainOutTransferDataList(address, pageNumber), TransferDirection.OUT);

  Future<List<Transfer>> _transformTransferDataList(List<TransferData> dataList, TransferDirection direction) async =>
      await Future.wait(dataList.map((data) async => Transfer(
        data: data,
        direction: direction,
        foreignAddressNamed: await _namedAddressService.obtainByAddressOrNull(
          Transfers.foreignAddressWithDirection(data, direction),
        ),
      )));
}