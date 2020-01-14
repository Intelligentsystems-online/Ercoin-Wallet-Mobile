import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryService {
  Future<Directory> obtainBackupDirectory() async {
    try {
      return await getExternalStorageDirectory();
    } catch(_) {
      return await getApplicationDocumentsDirectory();
    }
  }
}