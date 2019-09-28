import 'package:library_app/data/stats_repository.dart';
import 'package:meta/meta.dart';
import 'package:share/share.dart';

import 'package:library_app/providers/providers.dart';

class ExportService {
  final StorageProvider storageProvider;
  final StatsRepository statsRepository;

  ExportService({@required this.storageProvider, @required this.statsRepository})
    : assert(storageProvider != null, statsRepository != null);

  Future<List<int>> getYears() async {
    return await statsRepository.getYears();
  }

  Future<void> writeStats(int year) async {
    print('writeStats for ' + year.toString());
    String fileName = '$year.txt';

    String data = 'stats\n';
    await storageProvider.writeFile(fileName, data);
  }

  Future<void> shareStats(int year) async {
    Share.share('test test');
  }
}