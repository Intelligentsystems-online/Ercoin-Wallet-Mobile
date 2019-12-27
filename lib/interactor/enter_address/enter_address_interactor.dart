import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class EnterAddressFormInteractor {
  final NamedAddressService _namedAddressService;
  final LocalAccountService _localAccountService;
  final KeysFormatValidatorService _keysFormatValidatorService;

  EnterAddressFormInteractor(this._namedAddressService, this._localAccountService, this._keysFormatValidatorService);

  Future<String> validatePublicKey(String publicKey) async {
    final validationFormatResult = _keysFormatValidatorService.validatePublicKey(publicKey);

    return validationFormatResult ?? await _validateAddressExistence(Address.ofBase58(publicKey));
  }

  _validateAddressExistence(Address address) async {
    return await _validateNamedAddressExistence(address) ?? await _validateLocalAccountExistence(address);
  }

  _validateNamedAddressExistence(Address address) async =>
      await _namedAddressService.exists(address) ? "Address already exists" : null;

  _validateLocalAccountExistence(Address address) async =>
      await _localAccountService.exists(address) ? "Address already exists as account" : null;
}
