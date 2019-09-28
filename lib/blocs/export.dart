import 'package:bloc/bloc.dart';

import 'package:library_app/data/export_service.dart';

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
  final ExportService exportService;

  ExportBloc(this.exportService)
    : assert(exportService != null);

  @override
  ExportState get initialState => ExportInit();

  @override
  Stream<ExportState> mapEventToState(ExportEvent event) async* {
    if (event is LoadExportYearsEvent) {
      List<int> exportYears = await exportService.getYears();
      yield ExportYearsLoaded(exportYears: exportYears);
    }
    if (event is ExportYearEvent) {
      await exportService.writeStats(event.year);
      // await exportService.shareStats();
      yield YearExported();
    }
  }
}