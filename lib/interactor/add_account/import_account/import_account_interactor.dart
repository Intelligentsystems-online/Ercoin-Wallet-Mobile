import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ercoin_wallet/model/account_keys.dart';

class ImportAccountInteractor {
  Future<AccountKeys> importFromFile(String path) async {
    final content = await File(path).readAsString();
    final publicKey = jsonDecode(content)['publicKey'];
    final privateKey = jsonDecode(content)['privateKey'];

    return AccountKeys(publicKey, privateKey);
  }
}
