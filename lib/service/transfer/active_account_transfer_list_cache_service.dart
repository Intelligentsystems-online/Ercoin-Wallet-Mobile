import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_data.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/model/transfer/utils/transfers.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

import 'api/transfer_api_service.dart';

class ActiveAccountTransferListCacheService {
  static final _activeAccountPreferenceKey = 'active_account';
  static final Duration _invalidateDuration = Duration(minutes: 5);

  DateTime _lastInvalidateDate;
  List<Transfer> _transferList;
  String _activeAccount;

  final TransferApiService _apiService;
  final NamedAddressService _namedAddressService;
  final SharedPreferencesService _sharedPreferencesService;

  ActiveAccountTransferListCacheService(this._apiService, this._namedAddressService, this._sharedPreferencesService);

  Future<List<Transfer>> obtainTransferList() async {
    if(_shouldInvalidateCache()) {
      invalidateCache();
      _activeAccount = await _sharedPreferencesService.getSharedPreference(_activeAccountPreferenceKey);
      _transferList = await _fetchTransferList(Address(publicKey: _activeAccount));
    }

    return _transferList;
  }

  invalidateCache() async {
    _lastInvalidateDate = DateTime.now();
    _transferList = null;
    _activeAccount = null;
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

  bool _shouldInvalidateCache() => _transferList == null || _activeAccount == null || _isCacheExpired();

  bool _isCacheExpired() => DateTime.now().difference(_lastInvalidateDate) > _invalidateDuration;
}