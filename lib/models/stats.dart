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

  static const monthNames = {
    1: 'Januari',
    2: 'Februari',
    3: 'Mars',
    4: 'April',
    5: 'Maj',
    6: 'Juni',
    7: 'Juli',
    8: 'Augusti',
    9: 'September',
    10: 'Oktober',
    11: 'November',
    12: 'December'
  };

  MonthStats({String name, int count, this.month})
    : super(name, count);

  static MonthStats of(Map<String, dynamic> dbMap) {
    return MonthStats(
      month: dbMap['month'],
      name: monthNames[dbMap['month']],
      count: dbMap['tot']
    );
  }

  static int monthByName(String header) {
    int retValue = -1;
    monthNames.forEach((key, value) => {
      if (header.startsWith(value)) {
        retValue = key
      }
    });
    return retValue;
  }
}