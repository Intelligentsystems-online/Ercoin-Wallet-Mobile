import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/file/file_util.dart';

class ImportAccountInteractor {
  final AccountService _accountService;
  final FileUtil _fileUtil;

  ImportAccountInteractor(this._accountService, this._fileUtil);

  Future<List<String>> obtainAccountKeys() => _accountService
      .obtainAccounts()
      .then((accounts) => _obtainPublicKeys(accounts));

  Future<AccountKeys> importFromFile(String path) async {
    final json = await _fileUtil.readAsJson(path);

    if(_isJsonCorrect(json)) {
      final publicKey = json['publicKey'];
      final privateKey = json['privateKey'];

      return AccountKeys(publicKey, privateKey);
    }
    else throw FormatException("Incorrect json content.");
  }

  List<String> _obtainPublicKeys(List<Account> accounts) => accounts
      .map((account) => account.publicKey)
      .toList();

  bool _isJsonCorrect(Map<String, dynamic> json) =>
      json.containsKey('publicKey') && json.containsKey('privateKey');
}
