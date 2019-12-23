import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_data.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/model/transfer/utils/transfers.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

import 'api/transfer_api_service.dart';

class TransferCacheService {
  static final Duration _invalidateDuration = Duration(minutes: 5);

  DateTime _lastInvalidateDate;
  List<Transfer> _transferList;

  final TransferApiService _apiService;
  final NamedAddressService _namedAddressService;

  TransferCacheService(this._apiService, this._namedAddressService);

  Future<List<Transfer>> obtainTransferList(Address address) async {
    if(_shouldInvalidateCache())
      await invalidateCacheFor(address);

    return _transferList;
  }

  Future invalidateCacheFor(Address address) async {
    _lastInvalidateDate = DateTime.now();
    _transferList = await _fetchTransferList(address);
  }

  Future<List<Transfer>> _fetchTransferList(Address address) async {
    final transferLists = await Future.wait([
      _obtainAddressInTransferList(address),
      _obtainAddressOutTransferList(address),
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
        foreignAddressNamed: await _namedAddressService.obtainByAddressOrNull(
          Transfers.foreignAddressWithDirection(data, direction),
        ),
      )));

  bool _shouldInvalidateCache() => _transferList == null || _isCacheExpired();

  bool _isCacheExpired() => DateTime.now().difference(_lastInvalidateDate) > _invalidateDuration;
}