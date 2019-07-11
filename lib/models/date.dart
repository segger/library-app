class ReadDate {
  int year;
  int month;
  int day;

  ReadDate({this.year, this.month, this.day});

  String asLabel() {
    String fMonth = (this.month < 10) ? "0$month" : "$month";
    String fDay = (this.day < 10) ? '0$day' : '$day';
    return '$year-$fMonth-$fDay';
  }

  static ReadDate of(String date) {
    var bookDate = date.split('-');
    int year = int.parse(bookDate[0]);
    int month = int.parse(bookDate[1]);
    int day = int.parse(bookDate[2]);
    return ReadDate(year: year, month: month, day: day);
  }

  Map<String, int> asSearchParams() {
    return {
      "year": year,
      "month": month,
      "day": day
    };
  }
}