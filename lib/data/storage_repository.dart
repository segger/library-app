import 'package:meta/meta.dart';

import 'package:library_app/providers/storage_provider.dart';

class StorageRepository {
  final StorageProvider storageProvider;

  StorageRepository({@required this.storageProvider})
    : assert(storageProvider != null);

  Future<void> writeStats() async {
    String fileName = 'stats.txt';
    String data = 'test\n';
    await storageProvider.writeFile(fileName, data);
  }
}