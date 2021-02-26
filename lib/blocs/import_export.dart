import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:library_app/data/export_service.dart';

abstract class ImportExportState {}

class ExportInit extends ImportExportState {}
class ExportYearsLoaded extends ImportExportState {
  final List<int> exportYears;
  ExportYearsLoaded({this.exportYears});
}
class YearExported extends ImportExportState {}
class ImportFileValidated extends ImportExportState {
  final bool isValidLibraryFile;
  ImportFileValidated({this.isValidLibraryFile});
}
class FileImported extends ImportExportState {}

abstract class ImportExportEvent {}

class LoadExportYearsEvent extends ImportExportEvent {}
class ExportYearEvent extends ImportExportEvent {
  final int year;
  ExportYearEvent({this.year});
}
class ImportFileValidateEvent extends ImportExportEvent {
  final File file;
  ImportFileValidateEvent({this.file});
}
class ImportFileEvent extends ImportExportEvent {}

class ImportExportBloc extends Bloc<ImportExportEvent, ImportExportState> {
  final ExportService exportService;

  ImportExportBloc(this.exportService)
    : assert(exportService != null);

  @override
  ImportExportState get initialState => ExportInit();

  @override
  Stream<ImportExportState> mapEventToState(ImportExportEvent event) async* {
    if (event is LoadExportYearsEvent) {
      List<int> exportYears = await exportService.getYears();
      yield ExportYearsLoaded(exportYears: exportYears);
    }
    if (event is ExportYearEvent) {
      await exportService.writeStats(event.year);
      await exportService.shareStats(event.year);
      yield YearExported();
    }
    if (event is ImportFileValidateEvent) {
      // await importService.validateLibraryFile(event.file);
      yield ImportFileValidated(isValidLibraryFile: true);
    }
    if (event is ImportFileEvent) {
      // await importService.importFile();
      yield FileImported();
    }
  }
}