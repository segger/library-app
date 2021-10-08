import 'dart:io';

class ImportService {

  ImportService();

  Future<bool> validateLibraryFile(File file) async {
    String input = await file.readAsString();
    print(input);
    return false;
  }

  Future<void> importFile(File file) async {
    print('import file');
  }
}