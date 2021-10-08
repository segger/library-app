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

  Future<int> importFile(File file) async {
    String input = await file.readAsString();
    List<Book> bookList = parser.addBooks(input);
    await bookRepository.addBooks(bookList);
    return bookList.length;
  }
}

class ImportFileParser {

  ImportFileParser();

  bool validate(String input) {
    List<Book> books = parse(input, validate: true);
    books.forEach((book) => print(book.asMap().toString()));
    return books.isNotEmpty;
  }

  List<Book> addBooks(String input) {
    return parse(input);
  }

  bool _isDateInfo(String row) {
    RegExp regexp = new RegExp(r"\d{4}-\d{2}-\d{2}");
    return regexp.hasMatch(row);
  }

  List<Book> parse(String input, {validate=false}) {
    List<Book> bookList = [];
    List<String> rows = input.split('\n').map((row) => row.trim()).where((row) => row.isNotEmpty).toList();

    int currentYear = 1984;
    int currentMonth = 1;
    int currentDay = -1;
    for (String row in rows) {
      if (row.startsWith('=')) {
        if (row.startsWith('==')) {
          String yearString = row.replaceAll('=','').trim().substring(0,4);
          if(int.tryParse(yearString) == null) {
            if (validate) print('int.parse(year)');
            return [];
          }
          currentYear = int.parse(yearString);
        } else {
          String monthString = row.replaceAll('=','').trim().toLowerCase();
          String camelCasedMonthString = "${monthString[0].toUpperCase()}${monthString.substring(1)}";
          currentMonth = MonthStats.monthByName(camelCasedMonthString);
        }
      } else if (_isDateInfo(row)) {
        String dayString = row.substring(row.length-2);
        if(int.tryParse(dayString) == null) {
          if (validate) print('int.parse(day)');
          return [];
        }
        currentDay = int.parse(dayString);
      } else {
        if (currentYear == 1984) {
          if (validate) print('year');
          return [];
        }
        if (currentMonth == -1) {
          if (validate) print('month');
          return [];
        }
        DateTime date = DateTime(currentYear, currentMonth);
        if (currentDay != -1) {
          date = DateTime(currentYear, currentMonth, currentDay);
        }
        List<String> bookInfo = row.split(' - ').map((tmp) => tmp.trim()).toList();
        if (bookInfo.length != 2) {
          if (validate) {
            bookInfo.forEach((b) => {
              print(b)
            });
          }
          return [];
        }
        Book book = new Book(title: bookInfo[0], author: bookInfo[1], date: date);
        bookList.add(book);
      }
    }
    return bookList;
  }
}