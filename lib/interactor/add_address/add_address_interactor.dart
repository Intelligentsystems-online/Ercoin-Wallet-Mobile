import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';

class AddAddressIntractor {
  final NamedAddressService _namedAddressService;
  final ActiveAccountTransferListCacheService _activeAccountTransferListCacheService;

  const AddAddressIntractor(this._namedAddressService, this._activeAccountTransferListCacheService);

  Future addAddress(Address address, String name) async {
    await _namedAddressService.create(address, name);
    _activeAccountTransferListCacheService.invalidateCache();
  }
}
