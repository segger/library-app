import 'package:meta/meta.dart';

import 'package:library_app/data/db_constants.dart';
import 'package:library_app/data/db_provider.dart';

import 'package:library_app/models/stats.dart';

class StatsRepository {
  final DBProvider statsProvider;

  StatsRepository({@required this.statsProvider})
    : assert(statsProvider != null);

  Future<List<YearStats>> getYearStats() async {
    List<Map<String, dynamic>> dbList = await statsProvider.getListGroupBy(
      DBConstants.STATS_TABLE, "year"
    );
    return List.generate(dbList.length, (i) {
      return YearStats.of(dbList[i]);
    });
  }

  Future<void> increase(StatsEntity stats) async {
    //upsert
    await statsProvider.insert(DBConstants.STATS_TABLE, stats.asMap());
  }
}