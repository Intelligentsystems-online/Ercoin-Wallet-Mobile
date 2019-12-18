import 'dart:convert';
import 'dart:io';
import 'package:ercoin_wallet/model/file/file_format.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as pathService;

class JsonFileService {
  Future<Map<String, dynamic>> readAsJson(String path) async {
    if(_isCorrectFormat(path)) {
      final content = await File(path).readAsString();

      return jsonDecode(content);
    }
    else throw FormatException();
  }

  bool _isCorrectFormat(String path) => FileFormat
      .values
      .map((format) => describeEnum(format))
      .contains(_extractFormatFrom(path));

  String _extractFormatFrom(String path) => pathService
      .extension(path)
      .substring(1)
      .toUpperCase();
}
