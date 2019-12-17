import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/service/addressBook/address_book_service.dart';
import 'package:ercoin_wallet/utils/service/common/keys_validation_util.dart';

class EnterAddressBookEntryInteractor {
  final AddressBookService _addressBookService;
  final KeysValidationUtil _keysValidationUtil;

  EnterAddressBookEntryInteractor(this._addressBookService, this._keysValidationUtil);

  String validatePublicKeyFormat(String publicKey) => _keysValidationUtil.validatePublicKey(publicKey);

  Future<String> validatePublicKey(String publicKey) async {
    final entries = await _addressBookService.obtainAddressBookEntries();
    final validationResult = _keysValidationUtil.validatePublicKey(publicKey);

    return validationResult == null ? _validateKeyInList(entries, publicKey) : validationResult;
  }

  _validateKeyInList(List<AddressBookEntry> keys, String key) => keys
      .map((entry) => entry.publicKey)
      .contains(key) ? "Public key is already used" : null;
}