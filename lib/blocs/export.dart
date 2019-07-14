import 'package:bloc/bloc.dart';

abstract class ExportState {}
class ExportInit extends ExportState {}
class ExportYearsLoaded extends ExportState {
  final List<int> exportYears;
  ExportYearsLoaded({this.exportYears});
}

abstract class ExportEvent {}
class LoadExportYearsEvent extends ExportEvent {}

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  @override
  ExportState get initialState => ExportInit();

  @override
  Stream<ExportState> mapEventToState(ExportEvent event) async * {
    if (event is LoadExportYearsEvent) {
      List<int> exportYears = [2018, 2019, 2020, 2021];
      yield ExportYearsLoaded(exportYears: exportYears);
    }
  }
}