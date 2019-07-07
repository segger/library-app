import 'package:bloc/bloc.dart';

import 'package:library_app/data/stats_repository.dart';
import 'package:library_app/models/stats.dart';

abstract class StatsState {}

class StatsInit extends StatsState {}
class StatsError extends StatsState {}
class StatsLoaded extends StatsState {
  List<Stats> stats;
  StatsLoaded({this.stats});
}

abstract class StatsEvent {}

class LoadStatsEvent extends StatsEvent {}
class AddBookStatsEvent extends StatsEvent {
  final ReadDate date;
  AddBookStatsEvent({this.date});
}

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsRepository statsRepository;

  StatsBloc(this.statsRepository)
    : assert(statsRepository != null);

  @override
  StatsState get initialState => StatsInit();

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is LoadStatsEvent) {
      try {
        List<YearStats> stats = await statsRepository.getYearStats();
        yield StatsLoaded(stats: stats);
      } catch (_) {
        yield StatsError();
      }
    }
    if (event is AddBookStatsEvent) {
      if (currentState is StatsLoaded) {
        await statsRepository.increase(StatsEntity(date: event.date, count: 1));
        List<YearStats> stats = await statsRepository.getYearStats();
        yield StatsLoaded(stats: stats);
      }
    }
  }
}