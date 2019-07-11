import 'package:library_app/models/date.dart';

export './date.dart';

class StatsEntity {
  final int id;
  final ReadDate date;
  int count;

  StatsEntity({this.id, this.date, this.count});

  Map<String, dynamic> asMap() {
    return {
      "id": id,
      "year": date.year,
      "month": date.month,
      "day": date.day,
      "count": count
    };
  }

  static StatsEntity of(Map<String, dynamic> dbMap) {
    return StatsEntity(
      id: dbMap['id'],
      date: ReadDate(
        year: dbMap['year'],
        month: dbMap['month'],
        day: dbMap['day']
      ),
      count: dbMap['count']
    );
  }
}

abstract class Stats {
  String name;
  int count;

  Stats(String name, int count) {
    this.name = name;
    this.count = count;
  }
}

class YearStats extends Stats {
  List<MonthStats> monthStats;

  YearStats({String name, int count, this.monthStats: const[]})
    : super(name, count);

  static YearStats of(Map<String, dynamic> dbMap) {
    return YearStats(
      name: dbMap['year'].toString(),
      count: dbMap['tot']
    );
  }
}

class MonthStats extends Stats {
  int month;
  MonthStats({String name, int count, this.month})
    : super(name, count);
}