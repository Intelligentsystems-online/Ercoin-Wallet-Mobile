import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:path_provider/path_provider.dart';

class BackupInteractor {
  Future<String> createBackup(LocalAccount localAccount) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(_prepareFilePath(directory.path, localAccount.namedAddress.name));

    final jsonContent = jsonEncode(LocalAccountKeys(address: localAccount.namedAddress.address, privateKey: localAccount.privateKey));

    await file.writeAsString(jsonContent);

    return file.path;
  }

  String _prepareFilePath(String directoryPath, String name) =>
      directoryPath + "/backup_${name}_${_currentTime()}.json";

  String _currentTime() => new DateTime.now().millisecondsSinceEpoch.toString();
}
