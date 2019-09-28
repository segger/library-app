import 'package:bloc/bloc.dart';

import 'package:library_app/data/repositories.dart';

abstract class ExportState {}

class ExportInit extends ExportState {}
class ExportYearsLoaded extends ExportState {
  final List<int> exportYears;
  ExportYearsLoaded({this.exportYears});
}
class YearExported extends ExportState {}

abstract class ExportEvent {}

class LoadExportYearsEvent extends ExportEvent {}
class ExportYearEvent extends ExportEvent {
  final int year;
  ExportYearEvent({this.year});
}

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final StatsRepository statsRepository;
  final StorageRepository storageRepository;

  ExportBloc(this.statsRepository, this.storageRepository)
    : assert(statsRepository != null, storageRepository != null);

  @override
  ExportState get initialState => ExportInit();

  @override
  Stream<ExportState> mapEventToState(ExportEvent event) async* {
    if (event is LoadExportYearsEvent) {
      List<int> exportYears = [2018, 2019];
      yield ExportYearsLoaded(exportYears: exportYears);
    }
    if (event is ExportYearEvent) {
      print(event.year);
      await storageRepository.writeStats();
      yield YearExported();
    }
  }
}