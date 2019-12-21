import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class EnterAddressInteractor {
  final NamedAddressService _namedAddressService;
  final LocalAccountService _localAccountService;
  final KeysFormatValidatorService _keysFormatValidatorService;

  EnterAddressInteractor(this._namedAddressService, this._localAccountService, this._keysFormatValidatorService);

  String validatePublicKeyFormat(String publicKey) => _keysFormatValidatorService.validatePublicKey(publicKey);

  Future<String> validatePublicKey(String publicKey) async {
    final addresses = await _namedAddressService.obtainList();
    final accounts = await _localAccountService.obtainList();

    final validationResult = _keysFormatValidatorService.validatePublicKey(publicKey);

    return validationResult == null ? _validateKeyInLists(accounts, addresses, publicKey) : validationResult;
  }

  _validateKeyInLists(List<LocalAccount> localAccounts, List<NamedAddress> namedAddresses, String key) {
    final validationAccountsResult = _validateKeyInAccountList(localAccounts, key);

    return validationAccountsResult == null ? _validateKeyInAddressList(namedAddresses, key) : validationAccountsResult;
  }

  _validateKeyInAddressList(List<NamedAddress> namedAddresses, String key) => namedAddresses
      .map((namedAddress) => namedAddress.address.publicKey)
      .contains(key) ? "Address is already used" : null;

  _validateKeyInAccountList(List<LocalAccount> localAccounts, String key) => localAccounts
      .map((localAccount) => localAccount.namedAddress.address.publicKey)
      .contains(key) ? "Address is already used as account" : null;
}
