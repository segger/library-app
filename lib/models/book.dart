class Book {
  final int id;
  String title;
  String author;
  String date;

  Book({this.id, this.title, this.author, this.date});

  Map<String, dynamic> asMap() {
    return {
      "id": id,
      "date": date,
      "title": title,
      "author": author,
    };
  }

  static Book of(Map<String, dynamic> dbMap) {
    return Book(
        id: dbMap['id'],
        date: dbMap['date'],
        title: dbMap['title'],
        author: dbMap['author'],
      );
  }
}