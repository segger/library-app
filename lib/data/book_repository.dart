import 'package:meta/meta.dart';

import 'package:library_app/data/db_constants.dart';
import 'package:library_app/data/db_provider.dart';

import 'package:library_app/models/book.dart';

class BookRepository {
  final DBProvider bookProvider;

  BookRepository({@required this.bookProvider})
    : assert(bookProvider != null);

  Future<List<Book>> getBookList() async {
    List<Map<String, dynamic>> dbList = await bookProvider.getAll(DBConstants.BOOKS_TABLE);
    return List.generate(dbList.length, (i) {
      return Book.of(dbList[i]);
    });
  }

  addBook(Book book) async {
    await bookProvider.insert(DBConstants.BOOKS_TABLE, book.asMap());
  }
}