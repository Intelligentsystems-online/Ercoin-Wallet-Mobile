import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/service/account/local_account_service.dart';
import 'package:ercoin_wallet/utils/service/common/keys_format_validator_service.dart';
import 'package:ercoin_wallet/utils/service/file/json_file_service.dart';

class ImportAccountInteractor {
  final AccountService _accountService;
  final FileUtil _fileUtil;
  final KeysValidationUtil _keysValidationUtil;

  ImportAccountInteractor(this._accountService, this._fileUtil, this._keysValidationUtil);

  Future<List<String>> obtainAccountKeys() async => _obtainPublicKeys(await _accountService.obtainAccounts());

  Future<AccountKeys> importFromFile(String path) async {
    final jsonContent = await _fileUtil.readAsJson(path);

    if(!_isJsonCorrect(jsonContent)) throw FormatException();

    final publicKey = jsonContent['publicKey'];
    final privateKey = jsonContent['privateKey'];

    return AccountKeys(publicKey, privateKey);
  }

  Future<String> validatePublicKey(String publicKey) async {
    final accounts = await _accountService.obtainAccounts();
    final validationResult = _keysValidationUtil.validatePublicKey(publicKey);

    return validationResult == null ? _validateKeyInList(accounts, publicKey) : validationResult;
  }

  String validatePrivateKey(String privateKey) => _keysValidationUtil.validatePrivateKey(privateKey);

  _validateKeyInList(List<Account> keys, String key) => keys
      .map((account) => account.publicKey)
      .contains(key) ? "Public key is already used" : null;

  List<String> _obtainPublicKeys(List<Account> accounts) => accounts
      .map((account) => account.publicKey)
      .toList();

  bool _isJsonCorrect(Map<String, dynamic> json) =>
      json.containsKey('publicKey') && json.containsKey('privateKey');
}

