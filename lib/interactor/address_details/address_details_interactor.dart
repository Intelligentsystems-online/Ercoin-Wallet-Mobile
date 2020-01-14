import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';
import 'package:ercoin_wallet/service/transfer/active_account_transfer_list_cache_service.dart';

class AddressDetailsInteractor {
  final NamedAddressService _namedAddressService;
  final ActiveLocalAccountService _activeLocalAccountService;
  final ActiveAccountTransferListCacheService _activeAccountTransferListCacheService;

  const AddressDetailsInteractor(this._namedAddressService, this._activeLocalAccountService, this._activeAccountTransferListCacheService);

  Future<bool> isActiveAccountRegistered() async {
    final account = await _activeLocalAccountService.obtainActiveAccountDetails();

    return account.isRegistered;
  }

  Future updateNameByPublicKey(String publicKey, String name) async {
    await _namedAddressService.updateNameByPublicKey(publicKey, name);
    _activeAccountTransferListCacheService.invalidateCache();
  }

  Future deleteAddressByPublicKey(String publicKey) async {
    await _namedAddressService.deleteByPublicKey(publicKey);
    _activeAccountTransferListCacheService.invalidateCache();
  }
}