import 'package:ercoin_wallet/service/named_address/named_address_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';

class AddressDetailsInteractor {
  final NamedAddressService _namedAddressService;
  final ActiveAccountTransferListCacheService _activeAccountTransferListCacheService;

  const AddressDetailsInteractor(this._namedAddressService, this._activeAccountTransferListCacheService);

  Future updateNameByPublicKey(String publicKey, String name) async {
    await _namedAddressService.updateNameByPublicKey(publicKey, name);
    _activeAccountTransferListCacheService.invalidateCache();
  }

  Future deleteAddressByPublicKey(String publicKey) async {
    await _namedAddressService.deleteByPublicKey(publicKey);
    _activeAccountTransferListCacheService.invalidateCache();
  }
}