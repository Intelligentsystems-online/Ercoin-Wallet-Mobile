import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class EnterAddressFormInteractor {
  final NamedAddressService _namedAddressService;
  final LocalAccountService _localAccountService;
  final KeysFormatValidatorService _keysFormatValidatorService;

  EnterAddressFormInteractor(this._namedAddressService, this._localAccountService, this._keysFormatValidatorService);

  Future<String> validateAddress(Address address) async {
    final validationResult = _keysFormatValidatorService.validatePublicKey(address.publicKey);

    return validationResult == null ? await _validateAddressExistence(address) : validationResult;
  }

  _validateAddressExistence(Address address) async {
    final validationResult = await _validateNamedAddressExistence(address);

    return validationResult == null ? await _validateLocalAccountExistence(address) : validationResult;
  }

  _validateNamedAddressExistence(Address address) async =>
      await _namedAddressService.exists(address) ? "Address already exists" : null;

  _validateLocalAccountExistence(Address address) async =>
      await _localAccountService.exists(address) ? "Address already exists as account" : null;
}
