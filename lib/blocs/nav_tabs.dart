import 'package:bloc/bloc.dart';

enum NavTabs { books, stats }

abstract class NavTabEvent {}
class ChangeTabEvent extends NavTabEvent {
  final NavTabs tab;
  ChangeTabEvent({this.tab});
}

class NavTabsBloc extends Bloc<NavTabEvent, NavTabs> {
  @override
  NavTabs get initialState => NavTabs.books;

  @override
  Stream<NavTabs> mapEventToState(NavTabEvent event) async* {
    if(event is ChangeTabEvent) {
      yield event.tab;
    }
  }
}