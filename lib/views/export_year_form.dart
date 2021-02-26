import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:library_app/blocs/import_export.dart';

import 'package:library_app/widgets/load_components.dart';

class ImportExportYearForm extends StatefulWidget {
  @override
  _ImportExportYearFormState createState() => _ImportExportYearFormState();
}

class _ImportExportYearFormState extends State<ImportExportYearForm> {
  ImportExportBloc _bloc;

  final _formKey = GlobalKey<FormState>();

  int _selectedYear;

  @override
  void initState() {
    _selectedYear = null;
    _bloc = BlocProvider.of<ImportExportBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import/Export"),),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, ImportExportState state) {
              if (state is ExportInit) {
                return Loading();
              }
              if (state is ExportYearsLoaded) {
                return _exportForm(state);
              }
              if (state is YearExported) {
                return Loading();
              }
              if (state is ImportFileValidated) {
                return AlertDialog(
                  title: Text('Alert'),
                  actions: [
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        _bloc.dispatch(ImportFileEvent());
                      },
                    ),
                  ],
                );
              }
              if (state is FileImported) {
                _bloc.dispatch(LoadExportYearsEvent());
                return Loading();
              }
              return null;
            }
          ),
        ),
      ),
    );
  }

  Widget _exportForm(ExportYearsLoaded state) {
    return Column(
      children: <Widget>[
        _importButton(),
        Divider(
          color: Colors.black,
        ),
        _yearDropdown(state),
        _submitButton(),
      ],
    );
  }

  Widget _yearDropdown(ExportYearsLoaded state) {
    return DropdownButtonFormField(
      value: _selectedYear,
      onChanged: (int value) {
        setState(() {
          _selectedYear = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'No year selected';
        }
        return null;
      },
      items: state.exportYears.map((int value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Year'
      ),
    );
  }

  Widget _importButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        child: Text('Import'),
        color: Colors.blue,
        onPressed: () {
          _filePick();
        },
      ),
    );
  }

  _filePick() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path);
      print("FILE: " + file.toString());
      // String input = await file.readAsString();
      _bloc.dispatch(ImportFileValidateEvent(file: file));
    }
  }

  Widget _submitButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        child: Text('Export'),
        color: Colors.blue,
        disabledColor: Colors.black38,
        onPressed: _selectedYear == null ? null : _submit,
      ),
    );
  }

  _submit() {
    if(_formKey.currentState.validate()) {
      _bloc.dispatch(ExportYearEvent(year: _selectedYear));
      Navigator.pop(context);
    }
  }
}