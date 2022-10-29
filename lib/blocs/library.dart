import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:library_app/data/book_repository.dart';
import 'package:library_app/models/book.dart';

abstract class LibraryState {}

class LibraryInit extends LibraryState {}

class LibraryError extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Book> books;
  final bool hasReachedMax;
  final SortOrder sortOrder;
  LibraryLoaded(this.books, this.sortOrder, {this.hasReachedMax});

  LibraryLoaded copyWith(
      {List<Book> books, SortOrder sortOrder, bool hasReachedMax}) {
    return LibraryLoaded(books ?? this.books, sortOrder ?? this.sortOrder,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

abstract class LibraryEvent {}

class LoadLibraryEvent extends LibraryEvent {
  LoadLibraryEvent();
}

class SortLibraryEvent extends LibraryEvent {
  final SortOrder sortOrder;
  SortLibraryEvent(this.sortOrder);
}

class AddBookLibraryEvent extends LibraryEvent {
  final Book book;
  AddBookLibraryEvent(this.book);
}

class EditBookLibraryEvent extends LibraryEvent {
  final Book book;
  EditBookLibraryEvent(this.book);
}

class DeleteBookLibraryEvent extends LibraryEvent {
  final Book book;
  DeleteBookLibraryEvent(this.book);
}

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final BookRepository bookRepository;

  final int _length = 100;

  LibraryBloc({@required this.bookRepository}) : assert(bookRepository != null);

  @override
  LibraryState get initialState => LibraryInit();

  @override
  Stream<LibraryState> mapEventToState(LibraryEvent event) async* {
    // if (event is LoadLibraryEvent && !_hasReachedMax(currentState)) {
    if (event is LoadLibraryEvent) {
      try {
        if (state is LibraryInit) {
          final List<Book> books =
              await getBookList(SortOrder.date, 0, _length);
          yield LibraryLoaded(books, SortOrder.date, hasReachedMax: false);
        }
        if (state is LibraryLoaded) {
          LibraryLoaded loadedState = (state as LibraryLoaded);
          final List<Book> books =
              await getBookList(loadedState.sortOrder, 0, _length);
          print(books);
          yield LibraryLoaded(books, loadedState.sortOrder,
              hasReachedMax: false);
        }
      } catch (_) {
        yield LibraryError();
      }
    }
    if (event is AddBookLibraryEvent) {
      if (state is LibraryLoaded) {
        Book newBook = await bookRepository.addBook(event.book);
        LibraryLoaded loadedState = (state as LibraryLoaded);
        final List<Book> updatedLibrary = List.from(loadedState.books)
          ..insert(0, newBook);
        yield LibraryLoaded(updatedLibrary, loadedState.sortOrder,
            hasReachedMax: false);
      } else {
        yield LibraryError();
      }
    }
    if (event is EditBookLibraryEvent) {
      if (state is LibraryLoaded) {
        await bookRepository.editBook(event.book);
        LibraryLoaded loadedState = (state as LibraryLoaded);
        int idx =
            loadedState.books.indexWhere((book) => book.id == event.book.id);
        final List<Book> updatedLibrary = List.from(loadedState.books)
          ..replaceRange(idx, idx + 1, [event.book]);
        yield LibraryLoaded(updatedLibrary, loadedState.sortOrder,
            hasReachedMax: false);
      }
    }
    if (event is DeleteBookLibraryEvent) {
      if (state is LibraryLoaded) {
        await bookRepository.deleteBook(event.book);
        LibraryLoaded loadedState = (state as LibraryLoaded);
        int idx =
            loadedState.books.indexWhere((book) => book.id == event.book.id);
        final List<Book> updatedLibrary = List.from(loadedState.books)
          ..removeAt(idx);
        yield LibraryLoaded(updatedLibrary, loadedState.sortOrder,
            hasReachedMax: false);
      }
    }
    if (event is SortLibraryEvent) {
      if (state is LibraryLoaded) {
        LibraryLoaded loadedState = (state as LibraryLoaded);
        switch (event.sortOrder) {
          case SortOrder.title:
            loadedState.books.sort((a, b) {
              return a.title.compareTo(b.title);
            });
            break;
          case SortOrder.author:
            loadedState.books.sort((a, b) {
              return a.author.compareTo(b.author);
            });
            break;
          case SortOrder.date:
          default:
            loadedState.books.sort((a, b) {
              return b.date.compareTo(a.date);
            });
            break;
        }

        final List<Book> sortedLibrary = List.from(loadedState.books);
        yield LibraryLoaded(sortedLibrary, event.sortOrder,
            hasReachedMax: loadedState.hasReachedMax);
      }
    }
  }

  // bool _hasReachedMax(LibraryState state) => state is LibraryLoaded && state.hasReachedMax;

  Future<List<Book>> getBookList(
      SortOrder sortOrder, int startIdx, int limit) async {
    return await bookRepository.getBookList(sortOrder, startIdx, limit);
  }
}
