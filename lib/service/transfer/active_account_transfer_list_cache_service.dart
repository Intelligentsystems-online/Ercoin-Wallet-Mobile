import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/service/transfer/api/transfer_api_service.dart';

import 'transfer_list_service.dart';

class ActiveAccountTransferListCacheService {
  static final Duration _invalidateDuration = Duration(minutes: 5);
  static final int _minTransfersSize = 10;

  List<Transfer> _transferList;
  LocalAccount _loadedAccount;
  DateTime _lastUpdate;
  int _lastInPage = 1;
  int _lastOutPage = 1;

  final TransferListService _transferListService;
  final TransferApiService _transferApiService;

  ActiveAccountTransferListCacheService(this._transferListService, this._transferApiService);

  Future<List<Transfer>> obtainTransferList(LocalAccount account) async {
    if(_loadedAccount != account || _shouldUpdate())
      await _update(account);

    return _transferList;
  }

  invalidateCache() => _lastUpdate = null;

  bool _shouldUpdate() => _lastUpdate == null || DateTime.now().difference(_lastUpdate) > _invalidateDuration;

  Future _update(LocalAccount account) async {
    _lastInPage = await _transferApiService.fetchInTransfersLastPageNumber(account.namedAddress.address);
    _lastOutPage = await _transferApiService.fetchOutTransfersLastPageNumber(account.namedAddress.address);
    _transferList = await _updateTransferList(account);
    _loadedAccount = account;
    _lastUpdate = DateTime.now();
  }

  Future<List<Transfer>> _updateTransferList(LocalAccount account) async {
    final inTransferList = await _fetchInTransfers(account.namedAddress.address, _lastInPage);
    final outTransferList = await _fetchOutTransfers(account.namedAddress.address, _lastOutPage);

    if(_shouldFetchMoreInTransfers(inTransferList.length))
      inTransferList.addAll(await _fetchInTransfers(account.namedAddress.address, _lastInPage - 1));

    if(_shouldFetchMoreOutTransfers(outTransferList.length))
      outTransferList.addAll(await _fetchOutTransfers(account.namedAddress.address, _lastOutPage - 1));

    return inTransferList + outTransferList;
  }

  Future<List<Transfer>> _fetchInTransfers(Address address, int pageNumber) async =>
      await _transferListService.obtainAddressInTransferList(address, pageNumber);

  Future<List<Transfer>> _fetchOutTransfers(Address address, int pageNumber) async =>
      await _transferListService.obtainAddressOutTransferList(address, pageNumber);

  _shouldFetchMoreInTransfers(int transfersAmount) => _lastInPage > 1 && transfersAmount < _minTransfersSize;

  _shouldFetchMoreOutTransfers(int transfersAmount) => _lastOutPage > 1 && transfersAmount < _minTransfersSize;
}