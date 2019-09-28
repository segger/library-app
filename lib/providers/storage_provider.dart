import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StorageProvider {
  StorageProvider._();
  static final StorageProvider instance = StorageProvider._();

  Future<String> get _localPath async {
    final docDir = await getApplicationDocumentsDirectory();
    return docDir.path;
  }

  Future<File> _localFile(String name) async {
    final _path = await _localPath;
    String path = join(_path, name);
    return File(path);
  }

  Future<File> writeFile(String name, String data) async {
    final file = await _localFile(name);
    return file.writeAsString(data);
  }
}