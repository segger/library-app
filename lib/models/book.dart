import 'package:library_app/models/date.dart';

export './date.dart';

class Book {
  final int id;
  String title;
  String author;
  ReadDate date;

  Book({this.id, this.title, this.author, this.date});

  Map<String, dynamic> asMap() {
    return {
      "id": id,
      "date": date.asLabel(),
      "title": title,
      "author": author,
    };
  }

  static Book of(Map<String, dynamic> dbMap) {
    return Book(
        id: dbMap['id'],
        date: ReadDate.of(dbMap['date']),
        title: dbMap['title'],
        author: dbMap['author'],
      );
  }
}