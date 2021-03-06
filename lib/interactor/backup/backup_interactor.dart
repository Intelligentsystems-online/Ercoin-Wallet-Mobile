import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/service/common/directory_service.dart';

class BackupInteractor {
  final DirectoryService _directoryService;

  const BackupInteractor(this._directoryService);

  Future<String> createBackup(LocalAccount localAccount) async {
    Directory directory = await _directoryService.obtainBackupDirectory();

    final file = File(_prepareFilePath(directory.path, localAccount.namedAddress.name));

    final jsonContent = jsonEncode({
      "publicKey": localAccount.namedAddress.address.base58,
      "privateKey": localAccount.privateKey.base58,
    });

    await file.writeAsString(jsonContent);

    return file.path;
  }

  String _prepareFilePath(String directoryPath, String name) =>
      directoryPath + "/backup_${name}_${_currentTime()}.json";

  String _currentTime() => new DateTime.now().millisecondsSinceEpoch.toString();
}
