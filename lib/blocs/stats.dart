import 'package:bloc/bloc.dart';

abstract class StatsState {}

class StatsInit extends StatsState {}
class StatsError extends StatsState {}
class StatsLoaded extends StatsState {}

abstract class StatsEvent {}

class LoadStatsEvent extends StatsEvent {}
class AddBookStatsEvent extends StatsEvent {}

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  @override
  StatsState get initialState => StatsInit();

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is LoadStatsEvent) {
      yield StatsLoaded();
    }
    if (event is AddBookStatsEvent) {
      yield StatsLoaded();
    }
  }
}