import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/blocs/export.dart';

import 'package:library_app/widgets/load_components.dart';

class ExportYearForm extends StatefulWidget {
  @override
  _ExportYearFormState createState() => _ExportYearFormState();
}

class _ExportYearFormState extends State<ExportYearForm> {
  ExportBloc _bloc;

  final _formKey = GlobalKey<FormState>();

  int _selectedYear;

  @override
  void initState() {
    _selectedYear = null;
    _bloc = BlocProvider.of<ExportBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Export"),),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, ExportState state) {
              if (state is ExportInit) {
                return Loading();
              }
              if (state is ExportYearsLoaded) {
                return _exportForm(state);
              }
              if (state is YearExported) {
                return Loading();
              }
            }
          ),
        ),
      ),
    );
  }

  Widget _exportForm(ExportYearsLoaded state) {
    return Column(
      children: <Widget>[
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
      print('exporting...');
      _bloc.dispatch(ExportYearEvent(year: _selectedYear));
      Navigator.pop(context);
    }
  }
}