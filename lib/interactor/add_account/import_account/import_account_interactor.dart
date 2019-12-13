import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/file/file_util.dart';

class ImportAccountInteractor {
  final AccountService _accountService;
  final FileUtil _fileUtil;

  ImportAccountInteractor(this._accountService, this._fileUtil);

  Future<List<String>> obtainAccountKeys() async => _obtainPublicKeys(await _accountService.obtainAccounts());

  Future<AccountKeys> importFromFile(String path) async {
    final jsonContent = await _fileUtil.readAsJson(path);

    if(!_isJsonCorrect(jsonContent)) throw FormatException();

    final publicKey = jsonContent['publicKey'];
    final privateKey = jsonContent['privateKey'];

    return AccountKeys(publicKey, privateKey);
  }

  List<String> _obtainPublicKeys(List<Account> accounts) => accounts
      .map((account) => account.publicKey)
      .toList();

  bool _isJsonCorrect(Map<String, dynamic> json) =>
      json.containsKey('publicKey') && json.containsKey('privateKey');
}
