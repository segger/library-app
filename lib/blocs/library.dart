import 'package:bloc/bloc.dart';

abstract class LibraryState {}

class LibraryInit extends LibraryState {}
class LibraryError extends LibraryState {}
class LibraryLoaded extends LibraryState {}

abstract class LibraryEvent {}

class LoadLibraryEvent extends LibraryEvent {}
class AddLibraryBookEvent extends LibraryEvent {}

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  @override
  LibraryState get initialState => LibraryInit();

  @override
  Stream<LibraryState> mapEventToState(LibraryEvent event) async* {
    if (event is LoadLibraryEvent) {
      yield LibraryLoaded();
    }
    if (event is AddLibraryBookEvent) {
      yield LibraryLoaded();
    }
  }
}