export './constants.dart';

class Book {
  final int id;
  String title;
  String author;
  DateTime date;

  Book({this.id, this.title, this.author, this.date});

  Map<String, dynamic> asMap() {
    return {
      "id": id,
      "year": date.year,
      "month": date.month,
      "day": date.day,
      "title": title,
      "author": author,
    };
  }

  static Book from(int id, int year, int month, int day, String title, String author) {
    return Book(id: id, date: DateTime(year, month, day), title: title, author: author);
  }

  static Book of(Map<String, dynamic> dbMap) {
    return Book(
        id: dbMap['id'],
        date: DateTime(
          dbMap['year'],
          dbMap['month'],
          dbMap['day']
        ),
        title: dbMap['title'],
        author: dbMap['author'],
      );
  }

  String dateAsLabel() {
    String fMonth = (this.date.month < 10) ? "0${date.month}" : "${date.month}";
    String fDay = (this.date.day < 10) ? '0${date.day}' : '${date.day}';
    return '${date.year}-$fMonth-$fDay';
  }
}