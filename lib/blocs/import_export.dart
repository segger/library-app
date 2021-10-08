import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:library_app/data/export_service.dart';
import 'package:library_app/data/import_service.dart';

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
class FileImported extends ImportExportState {
  final int nbrOfBooks;
  FileImported({this.nbrOfBooks});
}

abstract class ImportExportEvent {}

class LoadExportYearsEvent extends ImportExportEvent {}
class ExportYearEvent extends ImportExportEvent {
  final int year;
  final bool withDate;
  ExportYearEvent({this.year, this.withDate});
}
class ImportFileValidateEvent extends ImportExportEvent {
  final File file;
  ImportFileValidateEvent({this.file});
}
class ImportFileEvent extends ImportExportEvent {
  final File file;
  ImportFileEvent({this.file});
}

class ImportExportBloc extends Bloc<ImportExportEvent, ImportExportState> {
  final ExportService exportService;
  final ImportService importService;

  ImportExportBloc({this.exportService, this.importService})
    : assert(exportService != null, importService != null);

  @override
  ImportExportState get initialState => ExportInit();

  @override
  Stream<ImportExportState> mapEventToState(ImportExportEvent event) async* {
    if (event is LoadExportYearsEvent) {
      List<int> exportYears = await exportService.getYears();
      yield ExportYearsLoaded(exportYears: exportYears);
    }
    if (event is ExportYearEvent) {
      // await exportService.writeStats(event.year);
      await exportService.shareStats(event.year, event.withDate);
      yield YearExported();
    }
    if (event is ImportFileValidateEvent) {
      bool valid = await importService.validateLibraryFile(event.file);
      yield ImportFileValidated(isValidLibraryFile: valid);
    }
    if (event is ImportFileEvent) {
      int nbrOfBooks = await importService.importFile(event.file);
      yield FileImported(nbrOfBooks: nbrOfBooks);
    }
  }
}