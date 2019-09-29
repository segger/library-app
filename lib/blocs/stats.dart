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
class AddBookStatsEvent extends StatsEvent {
  final DateTime date;
  AddBookStatsEvent({this.date});
}
class EditBookStatsEvent extends StatsEvent {
  final DateTime oldDate;
  final DateTime newDate;
  EditBookStatsEvent({this.oldDate, this.newDate});
}
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
    if (event is AddBookStatsEvent) {
      if (currentState is StatsLoaded) {
        await statsRepository.increase(StatsEntity(date: event.date, count: 1));
        List<YearStats> stats = await statsRepository.getYearStats();
        yield StatsLoaded(stats: stats);
      }
    }
    if (event is EditBookStatsEvent) {
      print('EditBookStatsEvent');
      if (currentState is StatsLoaded) {
        print('StatsLoaded');
        if (event.oldDate.difference(event.newDate).inDays == 0) {
          print('No diff between ${event.oldDate} and ${event.newDate}');
          List<YearStats> currentStats = (currentState as StatsLoaded).stats;
          yield StatsLoaded(stats: currentStats);
        } else {
          await statsRepository.decrease(StatsEntity(date: event.oldDate, count: 1));
          await statsRepository.increase(StatsEntity(date: event.newDate, count: 1));
          List<YearStats> stats = await statsRepository.getYearStats();
        yield StatsLoaded(stats: stats);
        }
      }
    }
  }
}