import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:library_app/data/book_repository.dart';
import 'package:library_app/models/book.dart';

abstract class LibraryState {}

class LibraryInit extends LibraryState {}
class LibraryError extends LibraryState {}
class LibraryLoaded extends LibraryState {
  final List<Book> books;
  LibraryLoaded({this.books});
}

abstract class LibraryEvent {}

class LoadLibraryEvent extends LibraryEvent {}
class AddBookLibraryEvent extends LibraryEvent {
  final Book book;
  AddBookLibraryEvent({this.book});
}

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final BookRepository bookRepository;

  LibraryBloc({@required this.bookRepository})
    : assert(bookRepository != null);

  @override
  LibraryState get initialState => LibraryInit();

  @override
  Stream<LibraryState> mapEventToState(LibraryEvent event) async* {
    if (event is LoadLibraryEvent) {
      try {
        final List<Book> books = await bookRepository.getBookList();
        yield LibraryLoaded(books: books);
      } catch (_) {
        yield LibraryError();
      }
    }
    if (event is AddBookLibraryEvent) {
      if (currentState is LibraryLoaded) {
        await bookRepository.addBook(event.book);
        final List<Book> updatedLibrary =
          List.from((currentState as LibraryLoaded).books)
          ..add(event.book);
        yield LibraryLoaded(books: updatedLibrary);
      } else {
        yield LibraryError();
      }
    }
  }
}