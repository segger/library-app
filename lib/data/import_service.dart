import 'dart:io';
import 'package:library_app/models/stats.dart';
import 'package:meta/meta.dart';

import 'package:library_app/data/book_repository.dart';
import 'package:library_app/models/book.dart';

class ImportService {
  final BookRepository bookRepository;
  ImportFileParser parser = new ImportFileParser();

  ImportService({@required this.bookRepository})
    : assert(bookRepository != null);

  Future<bool> validateLibraryFile(File file) async {
    String input = await file.readAsString();
    return parser.validate(input);
  }

  Future<void> importFile(File file) async {
    print('import file');

    String input = await file.readAsString();
    List<Book> bookList = parser.addBooks(input);
    bookList.forEach((book) => print(book.asMap().toString()));
    // await bookRepository.addBooks(bookList);
  }
}

class ImportFileParser {

  ImportFileParser();

  bool validate(String input) {
    List<Book> books = parse(input, validate: true);
    return books.isNotEmpty;
  }

  List<Book> parse(String input, {validate=false}) {
    List<Book> bookList = [];
    List<String> rows = input.split('\n').map((row) => row.trim()).where((row) => row.isNotEmpty).toList();

    int currentYear = 1984;
    int currentMonth = 1;
    for (String row in rows) {
      if (row.startsWith('=')) {
        if (row.startsWith('==')) {
          String yearString = row.replaceAll('=','').trim();
          currentYear = int.parse("${yearString.substring(0,4)}");
        } else {
          String monthString = row.replaceAll('=','').trim().toLowerCase();
          String camelCasedMonthString = "${monthString[0].toUpperCase()}${monthString.substring(1)}";
          currentMonth = MonthStats.monthByName(camelCasedMonthString);
        }
      } else {
        DateTime date = DateTime(currentYear, currentMonth);
        if (currentYear == 1984) {
          print('year');
          return [];
        }
        if (currentMonth == -1) {
          print('month');
          return [];
        }
        List<String> bookInfo = row.split(' - ').map((tmp) => tmp.trim()).toList();
        if (bookInfo.length != 2) {
          print('book');
          bookInfo.forEach((b) => {
            print(b)
          });
          return [];
        }
        Book book = new Book(title: bookInfo[0], author: bookInfo[1], date: date);
        bookList.add(book);
      }
    }
    return bookList;
  }

  List<Book> addBooks(String input) {
    return parse(input);
  }
}