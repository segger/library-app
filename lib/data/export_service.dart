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
    Map<int, List<dynamic>> books = await statsRepository.getBooks(year);
    String data = generateYearData(year, stats, books);
    await storageProvider.writeFile(fileName, data);
  }

  Future<void> shareStats(int year) async {
    List<MonthStats> stats = await statsRepository.getMonthStats(year);
    Map<int, List<dynamic>> books = await statsRepository.getBooks(year);
    String data = generateYearData(year, stats, books);

    Share.share(data);
  }

  String generateYearData(int year, List<MonthStats> stats, Map<int, List<dynamic>> books) {
    var yearTot = 0;
    var buffer = StringBuffer();
    stats.forEach((month) {
      yearTot += month.count;
      buffer.write("= ${month.name}: ${month.count} =\n");
      books[month.month].forEach((book) {
        buffer.write("${book.title} - ${book.author}\n");
      });
      buffer.write("\n");
    });

    String data = "== $year: $yearTot ==\n\n" + buffer.toString();
    return data;
  }
}