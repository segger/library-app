import 'package:bloc/bloc.dart';

import 'package:library_app/models/stats.dart';
import 'package:library_app/data/stats_repository.dart';

abstract class StatsState {}

class StatsInit extends StatsState {}
class StatsError extends StatsState {}
class StatsLoaded extends StatsState {
  List<Stats> stats;
  StatsLoaded({this.stats});
}

abstract class StatsEvent {}

class LoadYearStatsEvent extends StatsEvent {}
class LoadMonthStatsEvent extends StatsEvent {
  final int year;
  LoadMonthStatsEvent({this.year});
}

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsRepository statsRepository;

  StatsBloc(this.statsRepository)
    : assert(statsRepository != null);

  @override
  StatsState get initialState => StatsInit();

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is LoadYearStatsEvent) {
      try {
        List<YearStats> stats = await statsRepository.getYearStats();
        yield StatsLoaded(stats: stats);
      } catch (_) {
        yield StatsError();
      }
    }
    if (event is LoadMonthStatsEvent) {
      if (currentState is StatsLoaded) {
        List<YearStats> currentStats = (currentState as StatsLoaded).stats;
        YearStats yearStats = currentStats
                  .firstWhere((yearStats) => 
                    int.parse(yearStats.name) == event.year,
                    orElse: () => null);
        if(yearStats != null) {
          List<MonthStats> monthStats = await statsRepository.getMonthStats(event.year);
          yearStats.monthStats = monthStats;
        }
        yield StatsLoaded(stats: currentStats);
      }
    }
  }
}