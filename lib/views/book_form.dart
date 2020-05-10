import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:library_app/models/book.dart';

typedef OnSaveCallback = Function(Book book);

class BookForm extends StatefulWidget {
  final OnSaveCallback onSave;
  final Book book;

  BookForm({@required this.onSave, this.book});

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();

  Book book;

  void _save() {
    _formKey.currentState.save();
    widget.onSave(book);
    Navigator.pop(context);
  }


  @override
  void initState() {
    // var dateLabel = widget.book.date != null ? widget.book.date.asLabel() : '';
    book = widget.book;
    super.initState();
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
    return DateTimeField(
      format: DateFormat("yyyy-MM-dd"),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          initialDate: currentValue ?? DateTime.now(),
        );
      },
      initialValue: book.date,
      validator: (value) {
        if(value == null) {
          return 'No date';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Date'
      ),
      onSaved: (value) => book.date = value,
    );
  }

  Widget _title() {
    return TextFormField(
      initialValue: book.title,
      validator: (value) {
        if(value.isEmpty) {
          return 'No title';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Title'
      ),
      onSaved: (value) => book.title = value,
    );
  }

  Widget _author() {
    return TextFormField(
      initialValue: book.author,
      validator: (value) {
        if(value.isEmpty) {
          return 'No author';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Author'
      ),
      onSaved: (value) => book.author = value,
    );
  }
}
