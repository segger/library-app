import 'package:meta/meta.dart';

import 'package:library_app/providers/db_constants.dart';
import 'package:library_app/providers/db_provider.dart';

import 'package:library_app/models/stats.dart';

class StatsRepository {
  final DBProvider statsProvider;
  final String tbl = DBConstants.STATS_TABLE;

  StatsRepository({@required this.statsProvider})
    : assert(statsProvider != null);

  Future<List<YearStats>> getYearStats() async {
    List<Map<String, dynamic>> dbList = await statsProvider.getListGroupBy(
      tbl, "year"
    );
    return dbList.isEmpty ? [] : List.generate(dbList.length, (i) {
      return YearStats.of(dbList[i]);
    });
  }

  Future<List<MonthStats>> getMonthStats(int year) async {
    var where = {'year': year};
    List<Map<String, dynamic>> dbList = await statsProvider.getListGroupByWhere(
      tbl, "month", where
    );
    return dbList.isEmpty ? [] : List.generate(dbList.length, (i) {
      return MonthStats.of(dbList[i]);
    });
  }

  Future<void> increase(StatsEntity stats) async {
    var searchParams = stats.dateAsSearchParams();
    List<Map<String, dynamic>> dbList = await statsProvider.getListByCols(tbl, searchParams);
    if(dbList.length == 0) {
      await statsProvider.insert(tbl, stats.asMap());
    } else {
      StatsEntity newStats = StatsEntity.of(dbList[0]);
      newStats.count++;
      statsProvider.update(tbl, newStats.asMap());
    }
  }

  Future<List<int>> getYears() async {
    List<Map<String, dynamic>> dbList = await statsProvider.getDistinct(
      tbl, "year"
    );
    return dbList.isEmpty ? [] : List.generate(dbList.length, (i) {
      return dbList[i]['year'];
    });
  }
}