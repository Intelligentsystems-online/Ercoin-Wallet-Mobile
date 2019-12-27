import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/service/file/json_file_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';


class ImportAccountInteractor {
  final LocalAccountService _localAccountService;
  final JsonFileService _jsonFileService;
  final KeysFormatValidatorService _keysFormatValidatorService;

  ImportAccountInteractor(this._localAccountService, this._jsonFileService, this._keysFormatValidatorService);

  Future<LocalAccountKeys> importFromFile(String path) async {
    final jsonContent = await _jsonFileService.readAsJson(path);

    if(!_isJsonCorrect(jsonContent)) throw FormatException();

    return LocalAccountKeys(
      address: Address.ofBase58(jsonContent['publicKey']),
      privateKey: PrivateKey.ofBase58(jsonContent['privateKey'])
    );
  }

  Future<String> validatePublicKey(String publicKey) async {
    final localAccounts = await _localAccountService.obtainList();
    final validationResult = _keysFormatValidatorService.validatePublicKey(publicKey);

    return validationResult == null ? _validateKeyInList(localAccounts, publicKey) : validationResult;
  }

  String validatePrivateKey(String privateKey) => _keysFormatValidatorService.validatePrivateKey(privateKey);

  _validateKeyInList(List<LocalAccount> keys, String key) => keys
      .map((account) => account.namedAddress.address.base58)
      .contains(key) ? "Public key is already used" : null;

  bool _isJsonCorrect(Map<String, dynamic> json) =>
      json.containsKey('publicKey') && json.containsKey('privateKey');
}

