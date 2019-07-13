import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/blocs/library.dart';
import 'package:library_app/models/book.dart';

import 'package:library_app/widgets/load_components.dart';

class BooksPage extends StatefulWidget {
  
  @override  
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  LibraryBloc _bloc;

  final _scrollController = ScrollController();
  final _scrollThreashold = 200.0;

  @override
  void initState() {
    _bloc = BlocProvider.of<LibraryBloc>(context);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreashold) {
      _bloc.dispatch(LoadLibraryEvent());
    }
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
      itemCount: state.books.length,
      itemBuilder: (context, position) {
        return _libraryItem(state.books[position]);
      },
      controller: _scrollController,
    );
  }

  Widget _libraryItem(Book book) {
    return Card(
      child: ListTile(
        title: Text('${book.title} - ${book.author}'),
          subtitle: book.date != null ? Text(book.date.asLabel()) : Text(''),
      ),
    );
  }
}