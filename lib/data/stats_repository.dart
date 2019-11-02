import 'package:meta/meta.dart';

import 'package:library_app/providers/db_constants.dart';
import 'package:library_app/providers/db_provider.dart';

import 'package:library_app/models/stats.dart';

class StatsRepository {
  final DBProvider statsProvider;
  final String tbl = DBConstants.BOOKS_TABLE;

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

  Future<List<int>> getYears() async {
    List<Map<String, dynamic>> dbList = await statsProvider.getOrderedDistinct(
      tbl, "year"
    );
    return dbList.isEmpty ? [] : List.generate(dbList.length, (i) {
      return dbList[i]['year'];
    });
  }
}