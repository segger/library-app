import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:library_app/models/book.dart';

typedef OnSaveCallback = Function(Book book);

class AddBookForm extends StatefulWidget {
  final OnSaveCallback onSave;

  AddBookForm({@required this.onSave});

  @override
  _AddBookFormState createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  void _save() {
    var newBook = Book(
      date: _dateController.value.text,
      title: _titleController.value.text,
      author: _authorController.value.text,
    );
    widget.onSave(newBook);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: _body(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text("Add book"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _save();
            }
          },
        )
      ],
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: _formFields(),
      ),
    );
  }

  Widget _formFields() {
    return Column(
      children: <Widget>[
        _date(),
        _title(),
        _author(),
      ],
    );
  }

  Widget _date() {
    return DateTimePickerFormField(
      format: DateFormat("yyyy-MM-dd"),
      inputType: InputType.date,
      controller: _dateController,
      validator: (value) {
        if(value == null) {
          return 'No date';
        }
      },
      decoration: InputDecoration(
        labelText: 'Date'
      ),
    );
  }

  Widget _title() {
    return TextFormField(
      controller: _titleController,
      validator: (value) {
        if(value.isEmpty) {
          return 'No title';
        }
      },
      decoration: InputDecoration(
          labelText: 'Title'
      ),
    );
  }

  Widget _author() {
    return TextFormField(
      controller: _authorController,
      validator: (value) {
        if(value.isEmpty) {
          return 'No author';
        }
      },
      decoration: InputDecoration(
        labelText: 'Author'
      ),
    );
  }
}
