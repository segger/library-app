import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/blocs/library.dart';

import 'package:library_app/widgets/load_components.dart';

class BooksPage extends StatefulWidget {
  
  @override  
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  LibraryBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<LibraryBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, LibraryState state) {
        if (state is LibraryInit) {
          return Loading();
        }
        if (state is LibraryError) {
          return LoadingError(errorText: 'Failed to read books');
        }
        if (state is LibraryLoaded) {
          return _libraryList(state);
        }
      },
    );
  }

  Widget _libraryList(LibraryLoaded state) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, position) {
        return _libraryItem();
      }
    );
  }

  Widget _libraryItem() {
    return Card(
      child: ListTile(
        title: Text('Vild och fri - Marilyn Halvorson'),
      ),
    );
  }
}