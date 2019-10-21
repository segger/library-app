import 'package:meta/meta.dart';

import 'package:library_app/providers/db_constants.dart';
import 'package:library_app/providers/db_provider.dart';

import 'package:library_app/models/book.dart';

class BookRepository {
  final DBProvider bookProvider;

  BookRepository({@required this.bookProvider})
    : assert(bookProvider != null);

  String _getOrderBy(SortOrder order) {
    switch(order) {
      case SortOrder.title:
        return DBConstants.BOOKS_COL_TITLE;
      case SortOrder.author:
        return DBConstants.BOOKS_COL_AUTHOR;
      case SortOrder.date:
      default:
        return "year, month, day desc";
    }
  }

  Future<List<Book>> getBookList(SortOrder sortOrder, int startIdx, int limit) async {
    String orderBy = _getOrderBy(sortOrder);
    List<Map<String, dynamic>> dbList = await bookProvider.getAll(DBConstants.BOOKS_TABLE, orderBy, limit, startIdx);
    return dbList.isEmpty ? [] : List.generate(dbList.length, (i) {
      return Book.of(dbList[i]);
    });
  }

  addBook(Book book) async {
    await bookProvider.insert(DBConstants.BOOKS_TABLE, book.asMap());
  }

  editBook(Book book) async {
    await bookProvider.update(DBConstants.BOOKS_TABLE, book.asMap());
  }
}