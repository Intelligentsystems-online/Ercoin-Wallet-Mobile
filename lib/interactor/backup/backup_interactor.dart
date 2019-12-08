import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:path_provider/path_provider.dart';

class BackupInteractor {
  Future<String> createBackup(Account account) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(_prepareFilePath(directory.path));
    final jsonContent = jsonEncode(AccountKeys(account.publicKey, account.privateKey));

    await file.writeAsString(jsonContent);

    return file.path;
  }

  String _prepareFilePath(String directoryPath) =>
      directoryPath + "/backup_${_currentTime()}.json";

  String _currentTime() => new DateTime.now().millisecondsSinceEpoch.toString();
}
