import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class EnterAddressFormInteractor {
  final NamedAddressService _namedAddressService;
  final KeysFormatValidatorService _keysFormatValidatorService;

  EnterAddressFormInteractor(this._namedAddressService, this._keysFormatValidatorService);

  String validatePublicKeyFormat(String publicKey) => _keysFormatValidatorService.validatePublicKey(publicKey);

  Future<String> validatePublicKey(String publicKey) async {
    final entries = await _namedAddressService.obtainList();
    final validationResult = _keysFormatValidatorService.validatePublicKey(publicKey);

    return validationResult == null ? _validateKeyInList(entries, publicKey) : validationResult;
  }

  _validateKeyInList(List<NamedAddress> namedAddresses, String key) => namedAddresses
      .map((namedAddress) => namedAddress.address.publicKey)
      .contains(key) ? "Public key is already used" : null;
}
