import 'package:meta/meta.dart';
import 'package:share/share.dart';

import 'package:library_app/data/stats_repository.dart';
import 'package:library_app/models/stats.dart';

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
    String fileName = '$year.txt';

    List<MonthStats> stats = await statsRepository.getMonthStats(year);
    String data = generateYearData(year, stats);
    await storageProvider.writeFile(fileName, data);
  }

  Future<void> shareStats(int year) async {
    List<MonthStats> stats = await statsRepository.getMonthStats(year);
    String data = generateYearData(year, stats);

    Share.share(data);
  }

  String generateYearData(int year, List<MonthStats> stats) {
    var yearTot = 0;
    var buffer = StringBuffer();
    stats.forEach((month) {
      yearTot += month.count;
      buffer.write("== ${month.name}: (${month.count}) ==\n");
    });

    String data = "= $year: ($yearTot) =\n" + buffer.toString();
    return data;
  }
}